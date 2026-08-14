import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/common/extensions/double_extensions.dart';

void main() {
  group('DoubleOpacity.alpha', () {
    test('0.0 returns 0', () => expect(0.0.alpha, 0));
    test('1.0 returns 255', () => expect(1.0.alpha, 255));
    test('0.5 returns 128', () => expect(0.5.alpha, 128));
    test('rounds 0.501 to 128', () => expect(0.501.alpha, 128));
    test('rounds 0.999 to 255', () => expect(0.999.alpha, 255));
    test('clamps value above 1.0 to 255', () => expect(2.0.alpha, 255));
    test('clamps negative value to 0', () => expect((-0.5).alpha, 0));
  });
}
