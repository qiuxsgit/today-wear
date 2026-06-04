import '../api/api_exception.dart';
import 'app_localizations.dart';

/// 把 API/网络异常映射为本地化文案（UI 层使用）。
///
/// 规则：服务端返回的 message 已按 Accept-Language 本地化，优先展示；
/// message 为空（网络层错误、无信封兜底等）时按错误码映射 l10n。
String localizedApiError(AppLocalizations l10n, Object error) {
  if (error is NetworkException) {
    return error.code == 'timeout' ? l10n.errRequestTimeout : l10n.errNetwork;
  }
  if (error is ApiException) {
    if (error.message.isNotEmpty) return error.message;
    switch (error.code) {
      case 'unauthorized':
        return l10n.errSessionExpired;
      case 'premium_required':
        return l10n.errPremiumRequired;
      case 'gfs_upload_failed':
      case 'gfs_upload_parse':
        return l10n.errUploadFailed;
    }
  }
  return l10n.errGeneric;
}
