# Async Lock

Control the flow of asynchronous operations by signaling all the waiting tasks whether they should wait or continue at a specific point.

Lock or unlock that flow.

## Features

* Control the flow of asynchronous operations
* Check the status of the lock
* Wait for the lock to be unlocked

## Getting started

Install it using pub:
```
flutter pub add async_lock
```

And import the package:
```dart
import 'package:async_lock/async_lock.dart';
```

## Usage

```dart
final lock = AsyncLock();

// Start with it locked
final lock = AsyncLock(locked: true);
```

Lock or unlock to let everything waiting go through
```dart
lock.lock();
lock.unlock();
```

Wait for the lock to be unlocked, if it's already unlocked you will go right through it
```dart
await lock.wait();
```

Remove the lock when you're done using it
```dart
lock.remove();
```

## Is this what you're looking for?

`async_lock` allows you to control a flow, allowing multiple operations to continue at once only when you want, like opening a gate, or like a signal.

If what you're looking for is one by one like a queue, then check out the [`async_locks`](https://pub.dev/packages/async_locks) package.

## GitHub

The package code is available on Github: [Dart - AsyncLock](https://github.com/DrafaKiller/AsyncLock-dart)

## Example

```dart
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

// [Output]
// Wait, I will open the door after 3 seconds.

// 3 seconds later...

// [Output]
// Opening the door...
// Finally, I'm in!
```