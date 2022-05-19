library async_signal;

import 'dart:async';

/// # AsyncSignal
///
/// Control the flow of asynchronous operations by signaling all the waiting tasks whether they should wait or continue at a specific point.
///
/// Lock or unlock that flow.
///
/// ## Usage
///
/// ```dart
/// final signal = AsyncSignal(locked: true);
///
/// void getIn() async {
///     await signal.wait();
///     print('Finally, I\'m in!');
/// }
///
/// getIn();
/// print('Wait, I will open the door after 3 seconds.');
///
/// await Future.delayed(const Duration(seconds: 3));
///
/// print('Opening the door...');
/// signal.unlock();
///
/// // [Output]
/// // Wait, I will open the door after 3 seconds.
///
/// // 3 seconds later...
///
/// // [Output]
/// // Opening the door...
/// // Finally, I'm in!
/// ```
class AsyncSignal {
  final _controller = StreamController<bool>.broadcast();

  /// Stream of the signal state.
  Stream<bool> get stream => _controller.stream;

  /// Future with the next signal state.
  Future<bool> get future => _controller.stream.first;

  bool _locked;

  /// Set the signal state. This works the same as [lock] and [unlock] methods.
  bool get locked => _locked;
  set locked(bool locked) {
    _locked = locked;
    _controller.add(_locked);
  }

  AsyncSignal({bool locked = false}) : _locked = locked;

  /// Locking will prevent everyone waiting from passing through, until unlocked.
  void lock() => locked = true;

  /// Unlocking will allow everyone who was waiting to pass through.
  void unlock() => locked = false;

  /// Wait until the signal is unlocked.
  ///
  /// If the signal is already unlocked, this will continue immediately.
  ///
  /// ```dart
  /// await signal.wait();
  /// ```
  Future<void> wait() {
    if (!locked) return Future.value();
    return stream.firstWhere((locked) => locked == false);
  }

  /// Closing the signal will make it not signal any future waiting tasks.
  void close() => _controller.close();
}
