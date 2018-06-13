import 'package:test/test.dart';

import 'package:piecemeal/piecemeal.dart';

void main() {
  test("fill", () {
    var array = Array2D(3, 2, "before");
    array.fill("after");
    for (var y = 0; y < array.height; y++) {
      for (var x = 0; x < array.width; x++) {
        expect(array.get(x, y), "after");
      }
    }
  });
}
