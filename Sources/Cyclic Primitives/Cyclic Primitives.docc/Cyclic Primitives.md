# ``Cyclic_Primitives``

@Metadata {
    @DisplayName("Cyclic Primitives")
    @TitleHeading("Swift Institute — Primitives Layer")
}

Modular-arithmetic cyclic group types — both a dynamic-modulus surface where the modulus is container-owned, and a compile-time-modulus specialization where the modulus is a value generic and the element type is zero-sized.

## Overview

Cyclic groups ℤ/nℤ are the algebraic structure behind ring-buffer indices, circular navigation, modular arithmetic, and any wrap-around counting domain. This package separates the dynamic and static surfaces so consumers can pick the lifecycle that matches their data: a runtime-configured ring buffer reaches for ``Cyclic_Primitives/Cyclic/Group/Element`` + ``Cyclic_Primitives/Cyclic/Group/Modulus``; a known-capacity buffer reaches for ``Cyclic_Primitives/Cyclic/Group/Static``.

Both surfaces share the algebraic structure of a cyclic group under addition (closure, associativity, identity at `.zero`, inverse for every element) — they differ only in *where the modulus lives*. The package exposes both because either choice is the wrong default for some consumer.

Cyclic is part of **Story 2 of the data-structures cohort** (`data-structures-launch-2026`): seven packages introducing typed indexing and sequences — order, index, sequence, collection, input, **cyclic**, vector. Story 1 (cardinal, ordinal, affine) shipped 2026-05-12; Story 2 Wave 1 (order + index) shipped 2026-05-13. Cyclic depends on cardinal, ordinal, index, sequence, and Tier 0 utilities (comparison, hash, tagged).

## Topics

### Essentials

- <doc:Cyclic-Group>
- <doc:Cyclic-Group-Static>

### Dynamic surface

- ``Cyclic_Primitives/Cyclic/Group/Element``
- ``Cyclic_Primitives/Cyclic/Group/Modulus``

### Static (compile-time-modulus) surface

- ``Cyclic_Primitives/Cyclic/Group/Static``

### Namespace

- ``Cyclic_Primitives/Cyclic``
- ``Cyclic_Primitives/Cyclic/Group``
