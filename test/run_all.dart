import 'dart:math' as math;

import 'package:unittest/unittest.dart';

import 'direction_test.dart' as direction;
import 'rect_test.dart' as rect;
import 'vec_test.dart' as vec;

void main() {
  group("Direction", direction.main);
  group("Rect", rect.main);
  group("Vec", vec.main);
}