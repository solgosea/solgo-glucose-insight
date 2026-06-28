import 'dart:async';
import 'dart:convert';
import 'dart:io';

class MockCgmHttpServer {
  final List<Map<String, Object?>> entries;
  final bool requireToken;
  final String token;
  HttpServer? _server;
  final requestUris = <Uri>[];

  MockCgmHttpServer({
    required this.entries,
    this.requireToken = false,
    this.token = 'test-token',
  });

  Uri get baseUri {
    final server = _server;
    if (server == null) {
      throw StateError('MockCgmHttpServer has not started.');
    }
    return Uri.parse('http://127.0.0.1:${server.port}');
  }

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    unawaited(_serve());
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _serve() async {
    final server = _server;
    if (server == null) return;
    await for (final request in server) {
      requestUris.add(request.uri);
      if (requireToken && request.uri.queryParameters['token'] != token) {
        request.response.statusCode = HttpStatus.unauthorized;
        await request.response.close();
        continue;
      }
      request.response.headers.contentType = ContentType.json;
      if (request.uri.path == '/api/v1/status.json') {
        request.response.write(jsonEncode({'status': 'ok'}));
      } else if (request.uri.path == '/api/v1/entries/sgv.json' ||
          request.uri.path == '/api/v1/entries.json') {
        request.response.write(jsonEncode(_filterEntries(request.uri)));
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    }
  }

  List<Map<String, Object?>> _filterEntries(Uri uri) {
    final gte = int.tryParse(uri.queryParameters['find[date][\$gte]'] ?? '');
    final lte = int.tryParse(uri.queryParameters['find[date][\$lte]'] ?? '');
    final count = int.tryParse(uri.queryParameters['count'] ?? '');
    var rows = entries.where((entry) {
      final date = entry['date'];
      if (date is! num) return false;
      if (gte != null && date < gte) return false;
      if (lte != null && date > lte) return false;
      return true;
    }).toList();
    if (count != null && rows.length > count) {
      rows = rows.sublist(rows.length - count);
    }
    return rows;
  }
}
