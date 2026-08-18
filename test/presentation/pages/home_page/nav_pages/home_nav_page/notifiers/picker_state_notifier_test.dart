import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_state_notifier.dart';

void main() {
  late PickerStateNotifier notifier;

  setUp(() => notifier = PickerStateNotifier());
  tearDown(() => notifier.dispose());

  group('initial state', () {
    test('all buttons start as idle', () {
      expect(notifier.buttonStates, everyElement(ButtonPickerState.idle));
    });

    test('buttonStates has 5 elements', () {
      expect(notifier.buttonStates, hasLength(5));
    });

    test('containsSelectedItem is false', () {
      expect(notifier.containsSelectedItem, isFalse);
    });
  });

  group('updateState', () {
    test('sets state at the given index', () {
      notifier.updateState(2, ButtonPickerState.success);

      expect(notifier.buttonStates[2], ButtonPickerState.success);
    });

    test('does not affect other indices', () {
      notifier.updateState(2, ButtonPickerState.success);

      final others = [0, 1, 3, 4].map((i) => notifier.buttonStates[i]);
      expect(others, everyElement(ButtonPickerState.idle));
    });

    test('notifies listeners', () {
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.updateState(0, ButtonPickerState.success);

      expect(notified, isTrue);
    });

    test('ignores out-of-bounds index without throwing', () {
      expect(() => notifier.updateState(99, ButtonPickerState.success), returnsNormally);
      expect(notifier.buttonStates, everyElement(ButtonPickerState.idle));
    });

    test('success state persists — is not auto-reset', () {
      fakeAsync((async) {
        notifier.updateState(1, ButtonPickerState.success);
        async.elapse(const Duration(seconds: 2));

        expect(notifier.buttonStates[1], ButtonPickerState.success);
      });
    });

    test('error state resets to idle after 1 second', () {
      fakeAsync((async) {
        notifier.updateState(1, ButtonPickerState.error);
        expect(notifier.buttonStates[1], ButtonPickerState.error);

        async.elapse(const Duration(seconds: 1));

        expect(notifier.buttonStates[1], ButtonPickerState.idle);
      });
    });

    test('error state does not reset before 1 second', () {
      fakeAsync((async) {
        notifier.updateState(1, ButtonPickerState.error);
        async.elapse(const Duration(milliseconds: 999));

        expect(notifier.buttonStates[1], ButtonPickerState.error);
      });
    });

    test('second error call on same index cancels the first timer', () {
      fakeAsync((async) {
        notifier.updateState(1, ButtonPickerState.error);
        async.elapse(const Duration(milliseconds: 500));

        // Second error — timer restarts
        notifier.updateState(1, ButtonPickerState.error);
        async.elapse(const Duration(milliseconds: 600));

        // Only 600ms since second call — should still be error
        expect(notifier.buttonStates[1], ButtonPickerState.error);

        async.elapse(const Duration(milliseconds: 400));
        expect(notifier.buttonStates[1], ButtonPickerState.idle);
      });
    });
  });

  group('resetColors', () {
    test('resets all states to idle', () {
      notifier.updateState(0, ButtonPickerState.success);
      notifier.updateState(3, ButtonPickerState.success);

      notifier.resetColors();

      expect(notifier.buttonStates, everyElement(ButtonPickerState.idle));
    });

    test('notifies listeners', () {
      var notified = false;
      notifier.updateState(0, ButtonPickerState.success);
      notifier.addListener(() => notified = true);

      notifier.resetColors();

      expect(notified, isTrue);
    });

    test('cancels pending error reset timer', () {
      fakeAsync((async) {
        notifier.updateState(1, ButtonPickerState.error);
        notifier.resetColors();

        // Timer would have fired here — but it was cancelled
        async.elapse(const Duration(seconds: 2));

        // Should remain idle (reset by resetColors, not re-set by the timer)
        expect(notifier.buttonStates[1], ButtonPickerState.idle);
      });
    });
  });

  group('containsSelectedItem', () {
    test('returns true when a button is success', () {
      notifier.updateState(0, ButtonPickerState.success);

      expect(notifier.containsSelectedItem, isTrue);
    });

    test('returns true when a button is error', () {
      fakeAsync((async) {
        notifier.updateState(0, ButtonPickerState.error);

        expect(notifier.containsSelectedItem, isTrue);
      });
    });

    test('returns false after error auto-resets', () {
      fakeAsync((async) {
        notifier.updateState(0, ButtonPickerState.error);
        async.elapse(const Duration(seconds: 1));

        expect(notifier.containsSelectedItem, isFalse);
      });
    });

    test('returns false when all states are idle', () {
      expect(notifier.containsSelectedItem, isFalse);
    });
  });

  group('buttonStates getter', () {
    test('returns an unmodifiable list', () {
      expect(
        () => (notifier.buttonStates as dynamic).add(ButtonPickerState.idle),
        throwsUnsupportedError,
      );
    });
  });
}
