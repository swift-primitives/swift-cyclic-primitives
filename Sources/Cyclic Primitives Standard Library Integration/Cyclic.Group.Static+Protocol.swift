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

// MARK: - ~Copyable Protocol Conformances
//
// These conformances enable `Cyclic.Group.Static<n>.Element` to work with generic code
// that uses `Equation.Protocol`, `Comparison.Protocol`, and `Hash.Protocol`
// for ~Copyable support.
//
// The existing implementations from `Hashable` and `Comparable` satisfy
// the `borrowing` requirements because `Cyclic.Group.Static<n>.Element` is `Copyable`.
//
// Gated to Swift <6.4 because SE-0499 makes the three institute protocols
// typealiases to their stdlib counterparts under 6.4+ — the `Hashable,
// Comparable` conformance on the `Element` struct decl already satisfies the
// institute protocols. The explicit conformances here become "redundant
// conformance" errors on 6.4.

#if swift(<6.4)
    public import Comparison_Primitives
    public import Cyclic_Group_Static_Element_Primitives
    internal import Hash_Primitives

    extension Cyclic.Group.Static.Element: Equation.`Protocol` {}
    extension Cyclic.Group.Static.Element: Comparison.`Protocol` {}
    extension Cyclic.Group.Static.Element: Hash.`Protocol` {}
#endif
