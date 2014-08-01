Piecemeal is a small [Dart][] library of low-level utility types aimed at 2D
games. In particular, I harvested it from my roguelike [Hauberk][].

[dart]: https://www.dartlang.org/
[hauberk]: https://github.com/munificent/hauberk

## Using it

Add it to your package's pubspec:

```yaml
dependencies:
  piecemeal: any
```

Import it:

```dart
import 'package:piecemeal/piecemeal.dart';
```

## Running tests

Piecemeal comes with a unit test suite. From the root directory of piecemeal,
run:

```dart
dart --checked test/run_all.dart 
```
