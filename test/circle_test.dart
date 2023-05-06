import 'package:piecemeal/piecemeal.dart';
import 'package:test/test.dart';

void main() {
  test("center", () {
    expect(Circle(Vec.zero, 4).center, equals(Vec.zero));
    expect(Circle(Vec(2, 3), 4).center, equals(Vec(2, 3)));
  });

  test("radius", () {
    expect(Circle(Vec.zero, 0).radius, equals(0));
    expect(Circle(Vec.zero, 1).radius, equals(1));
    expect(Circle(Vec.zero, 2).radius, equals(2));
    expect(Circle(Vec.zero, 20).radius, equals(20));
  });

  for (var radius = 0; radius < _circles.length; radius++) {
    var rows = _circles[radius];
    var center = Vec(rows[0].length ~/ 2, rows.length ~/ 2);
    group("circle radius $radius (at $center)", () {
      var circle = Circle(center, radius);

      var circlePoints = [...circle];
      var edgePoints = [...circle.edge];

      void testPoints(String label,
          void Function(Vec pos, bool inCircle, bool inEdge) body) {
        test(label, () {
          for (var y = 0; y < rows.length; y++) {
            var row = rows[y];
            for (var x = 0; x < row.length; x++) {
              var pos = Vec(x, y);
              body(pos, row[x] != '.', row[x] == '*');
            }
          }
        });
      }

      testPoints('contains()', (Vec pos, bool inCircle, bool inEdge) {
        if (inCircle) {
          expect(circle.contains(pos), isTrue,
              reason: 'Expected $pos to be in circle but was not.');
        } else {
          expect(circle.contains(pos), isFalse,
              reason: 'Expected $pos to not be in circle but was.');
        }
      });

      testPoints('isEdge()', (Vec pos, bool inCircle, bool inEdge) {
        if (inEdge) {
          expect(circle.isEdge(pos), isTrue,
              reason: 'Expected $pos to be in edge but was not.');
        } else {
          expect(circle.isEdge(pos), isFalse,
              reason: 'Expected $pos to not be in edge but was.');
        }
      });

      testPoints('iterated contents', (Vec pos, bool inCircle, bool inEdge) {
        if (inCircle) {
          expect(circlePoints.contains(pos), isTrue,
              reason: 'Expected $pos to be in iterated contents but was not.');
        } else {
          expect(circlePoints.contains(pos), isFalse,
              reason: 'Expected $pos to not be in iterated contents but was.');
        }
      });

      testPoints('iterated edge', (Vec pos, bool inCircle, bool inEdge) {
        if (inEdge) {
          expect(edgePoints.contains(pos), isTrue,
              reason: 'Expected $pos to be in iterated edge but was not.');
        } else {
          expect(edgePoints.contains(pos), isFalse,
              reason: 'Expected $pos to not be in iterated edge but was.');
        }
      });
    });
  }
}

/// Call this to regenerate the test data below.
void generateTestData() {
  for (var radius = 0; radius <= 10; radius++) {
    var boxSize = radius * 2 + 3;
    var circle = Circle(Vec(boxSize ~/ 2, boxSize ~/ 2), radius);
    var points = {...circle};
    print('  // Radius $radius:');
    print('  [');
    for (var y = 0; y < boxSize; y++) {
      var row = '    \'';
      for (var x = 0; x < boxSize; x++) {
        row += points.contains(Vec(x, y))
            ? (circle.isEdge(Vec(x, y)) ? '*' : 'O')
            : '.';
      }
      row += '\',';
      print(row);
    }
    print('  ],');
  }
}

const _circles = [
  // Radius 0:
  [
    '...',
    '.*.',
    '...',
  ],
  // Radius 1:
  [
    '.....',
    '.***.',
    '.*O*.',
    '.***.',
    '.....',
  ],
  // Radius 2:
  [
    '.......',
    '..***..',
    '.*OOO*.',
    '.*OOO*.',
    '.*OOO*.',
    '..***..',
    '.......',
  ],
  // Radius 3:
  [
    '.........',
    '...***...',
    '..*OOO*..',
    '.*OOOOO*.',
    '.*OOOOO*.',
    '.*OOOOO*.',
    '..*OOO*..',
    '...***...',
    '.........',
  ],
  // Radius 4:
  [
    '...........',
    '....***....',
    '..**OOO**..',
    '..*OOOOO*..',
    '.*OOOOOOO*.',
    '.*OOOOOOO*.',
    '.*OOOOOOO*.',
    '..*OOOOO*..',
    '..**OOO**..',
    '....***....',
    '...........',
  ],
  // Radius 5:
  [
    '.............',
    '.....***.....',
    '...**OOO**...',
    '..*OOOOOOO*..',
    '..*OOOOOOO*..',
    '.*OOOOOOOOO*.',
    '.*OOOOOOOOO*.',
    '.*OOOOOOOOO*.',
    '..*OOOOOOO*..',
    '..*OOOOOOO*..',
    '...**OOO**...',
    '.....***.....',
    '.............',
  ],
  // Radius 6:
  [
    '...............',
    '......***......',
    '....**OOO**....',
    '...*OOOOOOO*...',
    '..*OOOOOOOOO*..',
    '..*OOOOOOOOO*..',
    '.*OOOOOOOOOOO*.',
    '.*OOOOOOOOOOO*.',
    '.*OOOOOOOOOOO*.',
    '..*OOOOOOOOO*..',
    '..*OOOOOOOOO*..',
    '...*OOOOOOO*...',
    '....**OOO**....',
    '......***......',
    '...............',
  ],
  // Radius 7:
  [
    '.................',
    '......*****......',
    '....***OOO***....',
    '...**OOOOOOO**...',
    '..**OOOOOOOOO**..',
    '..*OOOOOOOOOOO*..',
    '.**OOOOOOOOOOO**.',
    '.*OOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOO*.',
    '.**OOOOOOOOOOO**.',
    '..*OOOOOOOOOOO*..',
    '..**OOOOOOOOO**..',
    '...**OOOOOOO**...',
    '....***OOO***....',
    '......*****......',
    '.................',
  ],
  // Radius 8:
  [
    '...................',
    '.......*****.......',
    '.....**OOOOO**.....',
    '...**OOOOOOOOO**...',
    '...*OOOOOOOOOOO*...',
    '..*OOOOOOOOOOOOO*..',
    '..*OOOOOOOOOOOOO*..',
    '.*OOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOO*.',
    '..*OOOOOOOOOOOOO*..',
    '..*OOOOOOOOOOOOO*..',
    '...*OOOOOOOOOOO*...',
    '...**OOOOOOOOO**...',
    '.....**OOOOO**.....',
    '.......*****.......',
    '...................',
  ],
  // Radius 9:
  [
    '.....................',
    '.......*******.......',
    '.....***OOOOO***.....',
    '....**OOOOOOOOO**....',
    '...*OOOOOOOOOOOOO*...',
    '..**OOOOOOOOOOOOO**..',
    '..*OOOOOOOOOOOOOOO*..',
    '.**OOOOOOOOOOOOOOO**.',
    '.*OOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOO*.',
    '.**OOOOOOOOOOOOOOO**.',
    '..*OOOOOOOOOOOOOOO*..',
    '..**OOOOOOOOOOOOO**..',
    '...*OOOOOOOOOOOOO*...',
    '....**OOOOOOOOO**....',
    '.....***OOOOO***.....',
    '.......*******.......',
    '.....................',
  ],
  // Radius 10:
  [
    '.......................',
    '........*******........',
    '......**OOOOOOO**......',
    '.....*OOOOOOOOOOO*.....',
    '....*OOOOOOOOOOOOO*....',
    '...*OOOOOOOOOOOOOOO*...',
    '..*OOOOOOOOOOOOOOOOO*..',
    '..*OOOOOOOOOOOOOOOOO*..',
    '.*OOOOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOOOO*.',
    '.*OOOOOOOOOOOOOOOOOOO*.',
    '..*OOOOOOOOOOOOOOOOO*..',
    '..*OOOOOOOOOOOOOOOOO*..',
    '...*OOOOOOOOOOOOOOO*...',
    '....*OOOOOOOOOOOOO*....',
    '.....*OOOOOOOOOOO*.....',
    '......**OOOOOOO**......',
    '........*******........',
    '.......................',
  ],
];
