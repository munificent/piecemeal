import 'dart:math' as math;

import 'package:unittest/unittest.dart';

import 'direction_test.dart' as direction;
import 'vec_test.dart' as vec;

void main() {
  group("Direction", direction.main);
  group("Vec", vec.main);
}