import 'package:flutter_test/flutter_test.dart';
import 'package:strategy/strategy.dart';

void main() {
  test('adds value to the StgContext', () {
    final ctx = StgContext.background();
    ctx.inject('test', 0);
    expect(ctx.find<int>('test'), 0);
  });

  test('StgContext will be expired after timeout', () async {
    final ctx = StgContext.withTimeout(const Duration(milliseconds: 5));
    expect(ctx.expired, false);
    await Future.delayed(const Duration(milliseconds: 6));
    expect(ctx.expired, true);
    ctx.resetExpiration();
    expect(ctx.expired, false);
    await Future.delayed(const Duration(milliseconds: 7));
    expect(ctx.expired, true);
  });
}
