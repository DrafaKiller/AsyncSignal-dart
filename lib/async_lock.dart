library async_lock;

import 'dart:async';

/// # AsyncLock
/// 
/// Control the flow of asynchronous operations by signaling all the waiting tasks whether they should wait or continue in a specific point.
/// 
/// ## Usage
/// 
/// ```dart
/// final lock = AsyncLock(locked: true);
/// 
/// void getIn() async {
///     await lock.wait();
///     print('Finally, I\'m in!');
/// }
/// 
/// getIn();
/// print('Wait, I will open the door after 3 seconds.');
/// 
/// await Future.delayed(const Duration(seconds: 3));
/// 
/// print('Opening the door...');
/// lock.unlock();
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
class AsyncLock {
  final _controller = StreamController<bool>.broadcast();
  
  /// Stream of the lock state.
  Stream<bool> get stream => _controller.stream;

  /// Future with the next lock state.
  Future<bool> get future => _controller.stream.first;
  
  bool _locked;

  /// Set the lock state. This works the same as [lock] and [unlock] methods.
  bool get locked => _locked;
  set locked(bool locked) {
    _locked = locked;
    _controller.add(_locked);
  }

  AsyncLock({ bool locked = false }) : _locked = locked;

  /// Locking will prevent everyone waiting from passing through, until unlocked.
  void lock() => locked = true;

  /// Unlocking will allow everyone who was waiting to pass through.
  void unlock() => locked = false;

  /// Wait until the lock is unlocked.
  /// 
  /// If the lock is already unlocked, this will continue immediately.
  /// 
  /// ```dart
  /// await lock.wait();
  /// ```
  Future<void> wait() {
    if (!locked) return Future.value();
    return stream.firstWhere((locked) => locked == false);
  }

  /// Removing the lock will not signal any future waiting tasks.
  void remove() => _controller.close();
}