import '../l10n/app_localizations.dart';
import '../services/sync_service.dart';

/// SyncError → 用户可见文案（同步状态卡、首页下拉刷新等处复用）
String syncErrorText(SyncError? error, String? serverMessage, AppLocalizations l10n) {
  switch (error) {
    case SyncError.premiumRequired:
      return l10n.syncErrPremiumRequired;
    case SyncError.network:
      return l10n.errNetwork;
    case SyncError.server:
      return serverMessage ?? l10n.syncErrGeneric;
    case SyncError.unknown:
    case null:
      return l10n.syncErrGeneric;
  }
}
