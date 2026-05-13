# Cyclic.Group — dynamic surface

The runtime-modulus surface for cyclic-group arithmetic — `Cyclic.Group.Element` stores only the residue; `Cyclic.Group.Modulus` carries the > 0 invariant; the operations on `Cyclic.Group` accept both as parameters.

## Overview

`Cyclic.Group.Element` is the residue-only element type. It stores an `Ordinal` (the residue) and nothing else — the modulus is supplied by the caller at every operation. This is the right shape when:

- The modulus is **container-owned** (a ring buffer's capacity is the modulus for all its indices; storing the modulus inside each index would waste memory).
- The modulus is **configured at runtime** (a resizable buffer; a configuration-driven counter).
- The modulus **may change over the lifetime** of the data (resizing the underlying container reassigns the modulus to existing elements).

The `Cyclic.Group.Modulus` type wraps a `Cardinal` and encodes the `> 0` invariant via its throwing init — `init(_ value: Cardinal) throws(Self.Error)` rejects `Cardinal.zero` with `.zeroModulus`. Once constructed, the modulus is a safe parameter for every `Cyclic.Group.*` operation.

## Operations

The dynamic surface ships free-function operations on `Cyclic.Group` (not methods on Element), reflecting that the modulus is an external argument:

| Operation | Signature | Notes |
|-----------|-----------|-------|
| `successor` | `(Element, modulus: Modulus) -> Element` | Increment by 1, wrap at modulus. |
| `predecessor` | `(Element, modulus: Modulus) -> Element` | Decrement by 1, wrap at modulus. |
| `add` | `(Element, Element, modulus: Modulus) -> Element` | Group addition. |
| `subtract` | `(Element, Element, modulus: Modulus) -> Element` | Group subtraction (additive inverse). |
| `inverse` | `(Element, modulus: Modulus) -> Element` | `-a` such that `a + inverse(a) = .zero`. |
| `advanced` | `<Tag>(Element, by: Index<Tag>.Offset, modulus: Modulus) -> Element` | Signed-offset wrap-around. |

The free-function shape composes naturally with the container-owned-modulus pattern: the container holds the `Modulus` once, then threads it through every Element operation.

## Example: ring buffer head pointer

```swift
import Cyclic_Primitives

let capacity = try Cyclic.Group.Modulus(Cardinal(4))
var head = Cyclic.Group.Element.zero

head = Cyclic.Group.successor(head, modulus: capacity)  // 1
head = Cyclic.Group.successor(head, modulus: capacity)  // 2
head = Cyclic.Group.successor(head, modulus: capacity)  // 3
head = Cyclic.Group.successor(head, modulus: capacity)  // 0 (wraps)
```

## Typed-index integration

The dynamic surface accepts phantom-tagged indices and counts from `swift-index-primitives`:

```swift
private enum Slot {}

let capacity: Index<Slot>.Count = .init(Cardinal(8))
let modulus = try Cyclic.Group.Modulus(capacity)

let start: Index<Slot> = .init(_unchecked: Ordinal(3))
let element = Cyclic.Group.Element(__unchecked: start)
let advanced = Cyclic.Group.advanced(
    element,
    by: Index<Slot>.Offset(-5),
    modulus: modulus
)
```

`advanced(_:by:modulus:)` accepts both positive and negative offsets and computes wrap-around arithmetic correctly across the boundary.

## Topics

### Element

- ``Cyclic_Primitives/Cyclic/Group/Element``
- ``Cyclic_Primitives/Cyclic/Group/Element/zero``
- ``Cyclic_Primitives/Cyclic/Group/Element/one``

### Modulus

- ``Cyclic_Primitives/Cyclic/Group/Modulus``
- ``Cyclic_Primitives/Cyclic/Group/Modulus/Error``
