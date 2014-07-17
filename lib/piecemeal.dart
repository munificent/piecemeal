library piecemeal;

export 'src/array2d.dart';
export 'src/direction.dart';
export 'src/rect.dart';
export 'src/rng.dart';
export 'src/vec.dart';

sign(num n) {
  return (n < 0) ? -1 : (n > 0) ? 1 : 0;
}

num clamp(num min, num value, num max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}
