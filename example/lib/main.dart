import 'package:async_lock/async_lock.dart';

void main() async {
  final lock = AsyncLock(locked: true);

  void getIn() async {
      await lock.wait();
      print('Finally, I\'m in!');
  }

  getIn();
  print('Wait, I will open the door after 3 seconds.');

  await Future.delayed(const Duration(seconds: 3));

  print('Opening the door...');
  lock.unlock();
}

// [Output]
// Wait, I will open the door after 3 seconds.

// 3 seconds later...

// [Output]
// Opening the door...
// Finally, I'm in!