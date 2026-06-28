param(
  [int]$Port = 14120,
  [ValidateSet("fresh", "stale", "slow", "missingDevicestatus", "down")]
  [string]$Scenario = "fresh",
  [string]$ArtifactDir = "",
  [switch]$StopExisting
)

$ErrorActionPreference = "Stop"

if (-not $ArtifactDir) {
  $ArtifactDir = Join-Path (Resolve-Path ".").Path "scripts\.runtime"
}
New-Item -ItemType Directory -Force -Path $ArtifactDir | Out-Null

if ($StopExisting) {
  $connection = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue |
    Where-Object { $_.OwningProcess -gt 0 } |
    Select-Object -First 1
  if ($connection) {
    Stop-Process -Id $connection.OwningProcess -Force
  }
}

$serverPath = Join-Path $ArtifactDir "probe_nightscout_$Port.py"
$outPath = Join-Path $ArtifactDir "probe_nightscout_$Port.out.log"
$errPath = Join-Path $ArtifactDir "probe_nightscout_$Port.err.log"

$python = @"
import json
import sys
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse

port = int(sys.argv[1])
scenario = sys.argv[2]

def now_ms():
    return int(time.time() * 1000)

class Handler(BaseHTTPRequestHandler):
    def _write(self, status, payload, delay=0):
        if delay:
            time.sleep(delay)
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        sys.stdout.write("%s %s\n" % (self.path, fmt % args))
        sys.stdout.flush()

    def do_GET(self):
        path = urlparse(self.path).path
        delay = 2.5 if scenario == "slow" else 0
        ts = now_ms()
        if scenario == "stale":
            ts -= 45 * 60 * 1000
        if scenario == "down":
            self._write(503, {"status": "down", "error": "probe mock down"}, delay)
            return
        if path.endswith("/api/v1/status.json"):
            self._write(200, {"status": "ok", "serverTime": ts}, delay)
        elif path.endswith("/api/v1/entries.json"):
            self._write(200, [{"date": ts, "sgv": 118, "direction": "Flat"}], delay)
        elif path.endswith("/api/v1/devicestatus.json"):
            if scenario == "missingDevicestatus":
                self._write(200, [], delay)
            else:
                self._write(200, [{
                    "created_at": ts,
                    "uploader": {"battery": 86},
                    "openaps": {"suggested": {"bg": 118}, "iob": {"iob": 0.4}}
                }], delay)
        else:
            self._write(404, {"error": "not found"})

ThreadingHTTPServer(("127.0.0.1", port), Handler).serve_forever()
"@

Set-Content -Path $serverPath -Value $python -Encoding UTF8

$process = Start-Process `
  -FilePath "python" `
  -ArgumentList @($serverPath, $Port, $Scenario) `
  -RedirectStandardOutput $outPath `
  -RedirectStandardError $errPath `
  -PassThru `
  -WindowStyle Hidden

Start-Sleep -Milliseconds 600

[ordered]@{
  port = $Port
  scenario = $Scenario
  pid = $process.Id
  baseUrl = "http://127.0.0.1:$Port"
  stdout = $outPath
  stderr = $errPath
} | ConvertTo-Json -Compress
