import 'package:async_signal/async_signal.dart';

void main() async {
  final signal = AsyncSignal(locked: true);

  void getIn() async {
    await signal.wait();
    print('Finally, I\'m in!');
  }

  getIn();
  print('Wait, I will open the door after 3 seconds.');

  await Future.delayed(const Duration(seconds: 3));

  print('Opening the door...');
  signal.unlock();
}

// [Output]
// Wait, I will open the door after 3 seconds.

// 3 seconds later...

// [Output]
// Opening the door...
// Finally, I'm in!
