package info.nightscout.aapsclient.probe;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class AapsProbeFixtureReceiver extends BroadcastReceiver {
    private static final String TAG = "AapsProbeFixture";
    private static final String ACTION_SEND_CONTEXT = "com.metaguru.probe.AAPS_SEND_CONTEXT";
    private static final String ACTION_CONTEXT = "com.metaguru.probe.AAPS_CONTEXT";

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent == null || !ACTION_SEND_CONTEXT.equals(intent.getAction())) {
            return;
        }
        long timestamp = intent.getLongExtra("timestamp", System.currentTimeMillis());
        Log.i(TAG, "Forwarding AAPS context timestamp=" + timestamp);

        Intent outbound = new Intent(ACTION_CONTEXT);
        outbound.putExtra("timestamp", timestamp);
        outbound.putExtra("bgSource", stringExtra(intent, "bgSource", "xdrip"));
        outbound.putExtra("devicestatusObserved", intent.getBooleanExtra("devicestatusObserved", true));
        outbound.putExtra("loopContextObserved", intent.getBooleanExtra("loopContextObserved", true));
        outbound.putExtra("loopState", stringExtra(intent, "loopState", "visible"));
        context.sendBroadcast(outbound);

        Intent explicit = new Intent(outbound);
        explicit.setClassName(
                "com.metaguru.smartxdrip",
                "com.metaguru.smartxdrip.statusmonitor.aaps.AapsEvidenceReceiver");
        context.sendBroadcast(explicit);
        Log.i(TAG, "Forwarded explicit AAPS context to SolgoInsight");
    }

    private static String stringExtra(Intent intent, String key, String fallback) {
        String value = intent.getStringExtra(key);
        return value == null || value.length() == 0 ? fallback : value;
    }
}
