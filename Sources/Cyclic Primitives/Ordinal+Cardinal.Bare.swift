// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// Bare-type-vs-Carrier overload split for Ordinal × Cardinal.
//
// Upstream `Ordinal+Cardinal.swift` provides cross-Carrier overloads keyed on
// `C: Carrier.\`Protocol\`<Cardinal>`. Post the cardinal-cascade-drop, plain
// `Cardinal` no longer satisfies that constraint (its `Underlying` is now
// `UInt`, not `Cardinal` — only `Tagged<Tag, Cardinal>` (i.e. `Index<T>.Count`)
// satisfies it). Cyclic group arithmetic operates on bare `Cardinal` modulus
// values, so the bare-bare overloads must be supplied locally.
//
// This is the precedent set by ordinal-primitives' own migration, which split
// its typed-advance operator into `where Count == Cardinal` (bare path) and
// `where Count: Carrier.\`Protocol\`<Cardinal>` (Tagged path). Cyclic-primitives
// reproduces that split for the operators it actually consumes.

// MARK: - Ordinal % Cardinal → Ordinal (bare modular projection)

/// Projects an ordinal into a bounded range — bare-Cardinal companion to the
/// upstream `Ordinal % Carrier.\`Protocol\`<Cardinal>` overload.
@inlinable
public func % (lhs: Ordinal, rhs: Cardinal) -> Ordinal {
    Ordinal(lhs.underlying % rhs.underlying)
}

// MARK: - Ordinal < Cardinal → Bool (bare comparison)

/// Bare-Cardinal companion to the upstream cross-Carrier `<` overload.
@inlinable
public func < (lhs: Ordinal, rhs: Cardinal) -> Bool {
    lhs.underlying < rhs.underlying
}
