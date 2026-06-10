import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/nightscout/nightscout_url_normalizer.dart';

void main() {
  group('NightscoutUrlNormalizer', () {
    test('uses https for public hostnames', () {
      expect(
        NightscoutUrlNormalizer.normalize('example.fly.dev'),
        'https://example.fly.dev',
      );
    });

    test('uses http for local and private addresses', () {
      expect(
        NightscoutUrlNormalizer.normalize('127.0.0.1:1337'),
        'http://127.0.0.1:1337',
      );
      expect(
        NightscoutUrlNormalizer.normalize('10.20.100.26:1337'),
        'http://10.20.100.26:1337',
      );
      expect(
        NightscoutUrlNormalizer.normalize('192.168.1.20:1337'),
        'http://192.168.1.20:1337',
      );
      expect(
        NightscoutUrlNormalizer.normalize('172.16.0.5:1337'),
        'http://172.16.0.5:1337',
      );
    });

    test('keeps explicit schemes and removes trailing slash', () {
      expect(
        NightscoutUrlNormalizer.normalize('http://localhost:1337/'),
        'http://localhost:1337',
      );
      expect(
        NightscoutUrlNormalizer.normalize('https://example.fly.dev/'),
        'https://example.fly.dev',
      );
    });

    test('rejects blank values', () {
      expect(NightscoutUrlNormalizer.normalize('   '), isNull);
    });
  });
}
