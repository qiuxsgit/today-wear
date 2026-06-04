import 'package:flutter_test/flutter_test.dart';
import 'package:today_wear/screens/statistics_page.dart';

void main() {
  group('tagUsagePercent', () {
    test('两个各 1 次的标签 → 各 50%（回归：原 bug 都显示 100%）', () {
      expect(tagUsagePercent(1, 2), 50);
    });

    test('不同次数分布按总数占比', () {
      // A=2, B=1, 总数 3
      expect(tagUsagePercent(2, 3), 67);
      expect(tagUsagePercent(1, 3), 33);
    });

    test('单个标签独占 → 100%', () {
      expect(tagUsagePercent(5, 5), 100);
    });

    test('总数为 0 → 0%', () {
      expect(tagUsagePercent(0, 0), 0);
    });
  });
}
