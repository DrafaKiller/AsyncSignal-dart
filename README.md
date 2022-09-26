[![Pub.dev package](https://img.shields.io/badge/pub.dev-async_signal-blue)](https://pub.dev/packages/async_signal)
[![GitHub repository](https://img.shields.io/badge/GitHub-AsyncSignal--dart-blue?logo=github)](https://github.com/DrafaKiller/AsyncSignal-dart)

# Async Signal

Control the flow of asynchronous operations by signaling all the waiting tasks whether they should wait or continue at a specific point.

Lock or unlock the flow.

## Features

* Control the flow of asynchronous operations
* Check the status of the signal
* Wait for the signal to be unlocked

## Getting started

Install it using pub:
```
flutter pub add async_signal
```

And import the package:
```dart
import 'package:async_signal/async_signal.dart';
```

## Usage

```dart
final signal = AsyncSignal();

// Start with it locked
final signal = AsyncSignal(locked: true);
```

Lock or unlock to let everything waiting go through
```dart
signal.lock();
signal.unlock();
```

Wait for the signal to be unlocked, if it's already unlocked you will go right through it
```dart
await signal.wait();
```

Close the signal when you're done using it
```dart
signal.close();
```

## Is this what you're looking for?

`async_signal` allows you to control a flow, allowing multiple operations to continue at once only when you want, like opening a gate.

If what you want is a control flow one by one, like in a queue, then you should check out the [`async_locks`](https://pub.dev/packages/async_locks) package.

## GitHub

The package code is available on Github: [Dart - AsyncSignal](https://github.com/DrafaKiller/AsyncSignal-dart)

## Example

```dart
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

// [Output]
// Wait, I will open the door after 3 seconds.

// 3 seconds later...

// [Output]
// Opening the door...
// Finally, I'm in!
```