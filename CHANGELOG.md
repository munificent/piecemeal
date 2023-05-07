## 2.0.0

Revamp `Circle`:

*   Added `contains()` directly to `Circle`.
*   The set of points in larger circles is tweaked to include more points so
*   that there isn't only a single point at each edge on the origin.
*   `isEdge()` now returns false for points not in the circle at all.
*   The set of edge points is exactly the points in the circle that are not in
    the circle of one smaller radius. Before, it seemed to try to be that, but
    not quite.

Revamp `Direction` and `Vec`:

*   Make `Direction` an enum so that switches on it provide better
    exhaustiveness checking.
*   Turn `VecBase` into `VecMixin`.

## 1.0.0

*   Migrate to null safety. The fill parameter to `Array2D` is now required.
*   Require a `T Function(Vec)` to `Array2D.generated()` and
    `Array2D.generate()`. Runtime overloading doesn't feel idiomatic today.

## 0.4.2

*   Better `hashCode` on `Vec` with fewer collisions.

## 0.4.1

*   Add `Vec.nearestDirection`.
*   Add `Vec.intercardinalNeighbors`.

## 0.4.0

*   `Rng.take()` no longer preserves order, but is faster. To preserve order,
    use `Rng.takeOrdered()`.
*   Add `Rng.round()`.
*   Add `Vec.neighbors` and `Vec.cardinalNeighbors`.

## 0.3.8

*   Add `Rng.countFromFloat()` and `Rng.normal()`.

## 0.3.6

*   Add `Array2D.fill()`.

## 0.3.5

*   Add `Rng.shuffle()` and `Rng.setSeed()`.

## 0.3.4

*   Add Line and Circle classes.

## 0.3.3

*   Add `Rng.percent()`.

## 0.3.2

*   Add `Rect.offset()`.

## 0.3.1

*   Fix type error.
*   Use real generic method syntax.

## 0.3.0

*   Get rid of implicit casts and dynamic.
*   Make `Rng.item()` and `Rng.take()` generic methods.
*   Add `Rng.float()`.

## 0.2.1

*   Make strong mode clean.
*   Fix bug in `Rect.clamp()`.

## 0.2.0

*   Make constants `lowerCamelCase`.
*   Remove `sign()` and `clamp()` since the Dart core libraries have them now.

## 0.1.1

*   Add `CARDINAL` and `INTERCARDINAL` direction lists to `Direction`.
