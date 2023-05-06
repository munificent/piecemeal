import 'package:piecemeal/piecemeal.dart';
import 'package:test/test.dart';

void main() {
  // TODO: intersect().
  // TODO: centerIn().

  test("empty", () {
    expect(Rect.empty.x, equals(0));
    expect(Rect.empty.y, equals(0));
    expect(Rect.empty.width, equals(0));
    expect(Rect.empty.height, equals(0));
  });

  test("Rect.posAndSize()", () {
    var rect = Rect.posAndSize(Vec(1, 2), Vec(3, 4));
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(3));
    expect(rect.height, equals(4));
  });

  test("Rect.leftTopRightBottom()", () {
    var rect = Rect.leftTopRightBottom(1, 2, 3, 4);
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(2));
    expect(rect.height, equals(2));
  });

  test("Rect.row()", () {
    var rect = Rect.row(1, 2, 3);
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(3));
    expect(rect.height, equals(1));
  });

  test("Rect.column()", () {
    var rect = Rect.column(1, 2, 3);
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(1));
    expect(rect.height, equals(3));
  });

  test("coordinates", () {
    var rect = Rect(-1, 2, 3, 4);
    expect(rect.pos, equals(Vec(-1, 2)));
    expect(rect.size, equals(Vec(3, 4)));
    expect(rect.x, equals(-1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(3));
    expect(rect.height, equals(4));

    expect(rect.left, equals(-1));
    expect(rect.top, equals(2));
    expect(rect.right, equals(2));
    expect(rect.bottom, equals(6));

    expect(rect.topLeft, equals(Vec(-1, 2)));
    expect(rect.topRight, equals(Vec(2, 2)));
    expect(rect.bottomRight, equals(Vec(2, 6)));
    expect(rect.bottomLeft, equals(Vec(-1, 6)));
  });

  test("negative size coordinates", () {
    var rect = Rect(1, 2, -3, -4);
    expect(rect.pos, equals(Vec(1, 2)));
    expect(rect.size, equals(Vec(-3, -4)));
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(-3));
    expect(rect.height, equals(-4));

    expect(rect.left, equals(-2));
    expect(rect.top, equals(-2));
    expect(rect.right, equals(1));
    expect(rect.bottom, equals(2));

    expect(rect.topLeft, equals(Vec(-2, -2)));
    expect(rect.topRight, equals(Vec(1, -2)));
    expect(rect.bottomRight, equals(Vec(1, 2)));
    expect(rect.bottomLeft, equals(Vec(-2, 2)));
  });

  // TODO: center.

  test("area", () {
    expect(Rect(-1, 2, 3, 4).area, equals(12));
    expect(Rect(0, 0, 1, 4).area, equals(4));
    expect(Rect(0, 0, 3, 1).area, equals(3));
    expect(Rect(0, 0, 3, 0).area, equals(0));

    // Can have negative area.
    expect(Rect(0, 0, -2, 3).area, equals(-6));
    expect(Rect(0, 0, 2, -3).area, equals(-6));
    expect(Rect(0, 0, -2, -3).area, equals(6));
  });

  test("toString()", () {
    expect(Rect(1, 2, 3, 4).toString(), equals("(1, 2)-(3, 4)"));
  });

  // TODO: inflate().

  test("offset()", () {
    var rect = Rect(1, 2, 3, 4);

    expect(rect.offset(5, 6), equals(Rect(6, 8, 3, 4)));

    expect(rect.offset(-5, -6), equals(Rect(-4, -4, 3, 4)));
  });

  // TODO: contains().
  // TODO: containsRect().

  test("clamp()", () {
    var rect = Rect(1, 2, 3, 4);

    // Inside.
    expect(rect.clamp(Vec(2, 3)), equals(Vec(2, 3)));

    // Left.
    expect(rect.clamp(Vec(0, 3)), equals(Vec(1, 3)));

    // Right.
    expect(rect.clamp(Vec(10, 3)), equals(Vec(4, 3)));

    // Top.
    expect(rect.clamp(Vec(2, 0)), equals(Vec(2, 2)));

    // Bottom.
    expect(rect.clamp(Vec(2, 8)), equals(Vec(2, 6)));

    // Corner.
    expect(rect.clamp(Vec(20, 30)), equals(Vec(4, 6)));
  });

  // TODO: iterator.
  // TODO: distanceTo().
  // TODO: trace().
}
