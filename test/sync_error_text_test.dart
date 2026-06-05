import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:today_wear/services/sync_service.dart';
import 'package:today_wear/widgets/sync_status_card.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('zh'));
  });

  group('syncErrorText', () {
    test('premiumRequired 映射会员提示', () {
      expect(syncErrorText(SyncError.premiumRequired, null, l10n),
          l10n.syncErrPremiumRequired);
    });

    test('network 映射网络错误', () {
      expect(syncErrorText(SyncError.network, null, l10n), l10n.errNetwork);
    });

    test('server 优先用服务端返回的文案', () {
      expect(syncErrorText(SyncError.server, '服务端已本地化的提示', l10n),
          '服务端已本地化的提示');
    });

    test('server 无文案时回落通用错误', () {
      expect(syncErrorText(SyncError.server, null, l10n), l10n.syncErrGeneric);
    });

    test('unknown 与 null 回落通用错误', () {
      expect(syncErrorText(SyncError.unknown, null, l10n), l10n.syncErrGeneric);
      expect(syncErrorText(null, null, l10n), l10n.syncErrGeneric);
    });
  });
}
