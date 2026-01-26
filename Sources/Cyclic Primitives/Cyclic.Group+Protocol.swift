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
// These conformances enable `Cyclic.Group<n>.Element` to work with generic code
// that uses `Equation.Protocol`, `Comparison.Protocol`, and `Hash.Protocol`
// for ~Copyable support.
//
// The existing implementations from `Hashable` and `Comparable` satisfy
// the `borrowing` requirements because `Cyclic.Group<n>.Element` is `Copyable`.

import Comparison_Primitives
import Hash_Primitives

extension Cyclic.Group.Element: Equation.`Protocol` {}
extension Cyclic.Group.Element: Comparison.`Protocol` {}
extension Cyclic.Group.Element: Hash.`Protocol` {}
