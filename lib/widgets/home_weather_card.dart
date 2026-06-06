import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/weather_tip_service.dart';
import '../theme/app_theme_tokens.dart';

/// 天气卡片（首页）— 四状态机：loading / success / permissionDenied / failed
class HomeWeatherCard extends StatefulWidget {
  final AppThemeTokens tt;
  const HomeWeatherCard({super.key, required this.tt});

  @override
  State<HomeWeatherCard> createState() => _HomeWeatherCardState();
}

class _HomeWeatherCardState extends State<HomeWeatherCard> {
  @override
  void initState() {
    super.initState();
    // 先触发 tip 服务单例初始化（挂 WeatherService 监听），再加载天气，
    // 保证首次 success 通知能被收到。幂等：service 内部有去重。
    WeatherTipService.instance;
    WeatherService.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    final tt = widget.tt;
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: Listenable.merge(
          [WeatherService.instance, WeatherTipService.instance]),
      builder: (context, _) {
        final svc = WeatherService.instance;
        final Weather? w = svc.weather;

        // 第一行（位置/提示）、温度、点击行为按状态分派
        String locationLine;
        String tempText;
        VoidCallback? onTap;
        switch (svc.status) {
          case WeatherStatus.loading:
            locationLine = '…';
            tempText = '--°';
            onTap = null;
          case WeatherStatus.success:
            locationLine =
                w!.city.isEmpty ? w.text : '${w.city} · ${w.text}';
            tempText = '${w.temp}°';
            onTap = null;
          case WeatherStatus.permissionDenied:
            locationLine = l10n.weatherPermissionDenied;
            tempText = '--°';
            onTap = () => WeatherService.instance.onTapDenied();
          case WeatherStatus.failed:
            locationLine = l10n.weatherFetchFailed;
            tempText = '--°';
            onTap = () => WeatherService.instance.load(force: true);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-0.77, -0.64),
                  end: const Alignment(0.77, 0.64),
                  colors: [tt.ink, tt.accent2],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Color(0x12554230), blurRadius: 28, offset: Offset(0, 12))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationLine,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tt.page.withValues(alpha: 0.8)),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          WeatherTipService.instance.tip ??
                              l10n.weatherPlaceholderAdvice,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tt.page),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    tempText,
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w300, color: tt.page),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
