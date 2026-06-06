/// 实时天气（服务端 GET /weather/now 返回）
///
/// 纯内存对象，不进 Drift 表——天气是瞬时数据，离线时显示失败态即可。
class Weather {
  final String city; // 反查失败为空字符串
  final String text; // 天气状况文字，服务端按 lang 本地化
  final int temp; // 摄氏度
  final String icon; // 和风图标码，本期未使用，预留
  final String obsTime; // ISO8601 观测时间，如 2026-06-06T10:00+08:00

  const Weather({
    required this.city,
    required this.text,
    required this.temp,
    required this.icon,
    required this.obsTime,
  });

  factory Weather.fromJson(Map<String, dynamic> j) => Weather(
        city: (j['city'] as String?) ?? '',
        text: (j['text'] as String?) ?? '',
        temp: (j['temp'] as num?)?.toInt() ?? 0,
        icon: (j['icon'] as String?) ?? '',
        obsTime: (j['obsTime'] as String?) ?? '',
      );
}
