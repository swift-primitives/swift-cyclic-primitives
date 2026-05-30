# Cyclic.Group.Static — compile-time-modulus surface

The value-generic-modulus surface for cyclic-group arithmetic — `Cyclic.Group.Static<let N: Int>` is a zero-sized type carrying the modulus as a compile-time type parameter; `Static<N>.Element` is the element type, distinct from `Static<M>.Element` whenever `N ≠ M`.

## Overview

`Cyclic.Group.Static<let modulus: Int>` uses Swift 6.3's value-generic-parameter feature to lift the modulus into the type system. The resulting type and its `Element` have the following properties:

- **Zero-sized.** `Cyclic.Group.Static<4>` carries no runtime storage; it exists only to anchor the namespace and the modulus value-generic parameter.
- **Type-distinct per modulus.** `Cyclic.Group.Static<4>.Element` is a different type from `Cyclic.Group.Static<8>.Element`; the compiler enforces that elements from different cyclic groups cannot be mixed in arithmetic.
- **Iterable as a `Sequence`.** Via `swift-cyclic-iterator-primitives`, the group conforms to both `Iterable` and `Swift.Sequence`; iterating produces every element of `[0, modulus)` exactly once. (Import `Cyclic_Iterator_Primitives` to opt in.)

This is the right shape when the modulus is **fixed at compile time** — a hash-table-bucket index, a small modular ring known at type-check time, a fixed wheel of states.

## Example: typed buffer index

```swift
import Cyclic_Primitives

var tail: Cyclic.Group.Static<4>.Element = .zero
tail += .one  // 1
tail += .one  // 2
tail += .one  // 3
tail += .one  // 0 (wraps)
```

The element type is `Cyclic.Group.Static<4>.Element` — `Cyclic.Group.Static<8>.Element` is a different type. Mixing elements from different cyclic groups is a compile-time error.

## Iteration

```swift
for element in Cyclic.Group.Static<5>() {
    print(element.position)  // 0, 1, 2, 3, 4
}
```

The iterator implements `next() -> Element?` as its primitive method, satisfying both `Iterator.\`Protocol\`` (from `swift-iterator-primitives`, scalar `next()` with `Failure == Never`) and `Swift.IteratorProtocol`. Elements are computed on demand from `0` to `modulus - 1`.

## Construction

`Cyclic.Group.Static<N>.Element` ships three init paths:

| Init | Signature | Behavior |
|------|-----------|----------|
| Throwing | `init(_ position: Ordinal) throws(Self.Error)` | Rejects `position >= modulus` with `.outOfBounds`; rejects `modulus <= 0` with `.invalidModulus`. |
| Unchecked | `init(__unchecked position: Ordinal)` | No validation. Caller asserts `position < modulus` and `modulus > 0`. |
| Wrapping | `init(wrapping position: Ordinal)` | Reduces `position % modulus`. Traps if `modulus <= 0`. |

## Arithmetic

The static surface ships operator overloads (`+`, `-`, `+=`, `-=`) and an `.inverse` property — the modulus is implicit in the type. Composition with `Tagged<Tag, Cyclic.Group.Static<N>.Element>` mirrors the bare-element arithmetic and the phantom-tag constraint forwards correctly through the operators.

```swift
let a: Cyclic.Group.Static<5>.Element = 4
let b: Cyclic.Group.Static<5>.Element = 3
let sum = a + b               // 2 — (4 + 3) mod 5
let inv = a.inverse           // 1 — a + inv == .zero
```

The `ExpressibleByIntegerLiteral` conformance used in the example is shipped in the `Cyclic Primitives Test Support` target; production code uses the throwing `init(_:)`.

## Topics

### Cyclic.Group.Static

- ``Cyclic_Primitives/Cyclic/Group/Static``

### Static.Element

- ``Cyclic_Primitives/Cyclic/Group/Static/Element``
- ``Cyclic_Primitives/Cyclic/Group/Static/Element/Error``
- ``Cyclic_Primitives/Cyclic/Group/Static/Iterator``
