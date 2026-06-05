import 'package:flutter_test/flutter_test.dart';
import 'package:today_wear/api/api_config.dart';

void main() {
  group('ApiConfig.staticPageUrl', () {
    test('无参数时只有路径', () {
      expect(
        ApiConfig.staticPageUrl('legal', 'privacy-policy'),
        endsWith('/static/legal/privacy-policy.html'),
      );
    });

    test('lang + bg + fg 全量拼接', () {
      expect(
        ApiConfig.staticPageUrl('legal', 'privacy-policy',
            lang: 'zh-CN', bg: '171513', fg: 'c9c2b8'),
        endsWith('/static/legal/privacy-policy.html?lang=zh-CN&bg=171513&fg=c9c2b8'),
      );
    });

    test('只传颜色不传 lang', () {
      expect(
        ApiConfig.staticPageUrl('legal', 'terms-of-service', bg: 'ffffff', fg: '111111'),
        endsWith('/static/legal/terms-of-service.html?bg=ffffff&fg=111111'),
      );
    });
  });
}
