import 'package:flutter_test/flutter_test.dart';
import 'package:today_wear/services/dist_channel.dart';

void main() {
  test('iOS 永远是 appstore', () {
    expect(DistChannel.resolveFor('play', isIOS: true, isAndroid: false), 'appstore');
    expect(DistChannel.resolveFor('apk', isIOS: true, isAndroid: false), 'appstore');
  });

  test('Android 按 dart-define 区分，未知值兜底 play（合规）', () {
    expect(DistChannel.resolveFor('play', isIOS: false, isAndroid: true), 'play');
    expect(DistChannel.resolveFor('apk', isIOS: false, isAndroid: true), 'apk');
    expect(DistChannel.resolveFor('', isIOS: false, isAndroid: true), 'play');
    expect(DistChannel.resolveFor('bogus', isIOS: false, isAndroid: true), 'play');
  });

  test('其他平台（macOS 等）不支持', () {
    expect(DistChannel.resolveFor('play', isIOS: false, isAndroid: false), isNull);
  });
}
