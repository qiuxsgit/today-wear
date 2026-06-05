import 'package:flutter_test/flutter_test.dart';
import 'package:today_wear/api/version_api.dart';

void main() {
  test('fromJson 完整字段', () {
    final r = VersionCheckResult.fromJson({
      'hasUpdate': true,
      'forceUpdate': true,
      'latestVersionName': '2.1.0',
      'latestVersionCode': 5,
      'notes': '修正若干問題',
      'downloadUrl': 'https://gfs.test/signed/42',
    });
    expect(r.hasUpdate, isTrue);
    expect(r.forceUpdate, isTrue);
    expect(r.latestVersionName, '2.1.0');
    expect(r.latestVersionCode, 5);
    expect(r.notes, '修正若干問題');
    expect(r.downloadUrl, 'https://gfs.test/signed/42');
  });

  test('fromJson 无更新时字段缺省', () {
    final r = VersionCheckResult.fromJson({'hasUpdate': false, 'forceUpdate': false});
    expect(r.hasUpdate, isFalse);
    expect(r.latestVersionCode, 0);
    expect(r.notes, '');
    expect(r.downloadUrl, isNull);
  });
}
