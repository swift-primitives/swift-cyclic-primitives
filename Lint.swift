// swift-linter-tools-version: 0.1
// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-cyclic-primitives open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-cyclic-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// Shape-γ unified consumer manifest. swift-cyclic-primitives owns the
// `Cyclic.Group.Static<N>.Element` brand-newtype (Tagged-wrapped
// Ordinal). Three swift-linter AST rules fire on legitimate-by-
// construction same-package access patterns at the brand's boundary:
//
//   - `raw value access` — `.position` accessor on the brand surface
//   - `unchecked call site` — `Element(__unchecked: ordinal)` canonical
//     typed-system bottom-out
//   - `tagged extension public init` — `Tagged+Cyclic.Group.Static.Element.swift`
//     domain-extension boundary
//
// **Stopgap**: per-package `.excluding(rules:)` silences these rules
// for the brand-newtype owner's own source. The cleaner destination is
// AST-layer rule refinement at `swift-foundations/swift-linter-rules` +
// `swift-primitives/swift-primitives-linter-rules` recognizing
// brand-newtype-owner same-package context — likely as
// `[RULE-EXEMPT-N]` shapes per the `rule-exemptions` skill. When the
// refined rules land, the `.excluding` block here retires.
//
// See `swift-foundations/swift-linter-rules/Research/numerics-rule-recognizer-2026-05-12.md`
// (Option 7: rule decomposition via bundle composition) for the
// architectural rationale of the per-package exclusion stopgap.
//
// Typed `Lint.Rule.ID` accessors require direct imports of the
// defining rule-pack modules under Swift 6.3+ `MemberImportVisibility`
// — re-exports through the umbrella `Linter Primitives Rules` do not
// satisfy member-import visibility per SE-0444.

import Linter
import Linter_Primitives_Rules
import Primitives_Linter_Rule_RawValue
import Institute_Linter_Rule_Structure
import Institute_Linter_Rule_Unchecked

Lint.run(dependencies: [
    .package(
        path: "../swift-primitives-linter-rules",
        products: ["Linter Primitives Rules", "Primitives Linter Rule RawValue"]
    ),
    .package(
        path: "../../swift-foundations/swift-institute-linter-rules",
        products: ["Institute Linter Rule Structure", "Institute Linter Rule Unchecked"]
    ),
]) {
    Lint.Rule.Bundle.primitives.excluding(rules: [
        // reason: `.position` accessor on Cyclic.Group.Static<N>.Element
        // is the brand-newtype's same-package boundary access per
        // [PATTERN-017]'s extension-initializers/same-package allowance.
        Lint.Rule.`raw value access`.id,
        // reason: `Element(__unchecked: ordinal)` is the canonical
        // typed-system bottom-out for the brand-newtype's domain-
        // validated construction per [CONV-016] same-package use.
        Lint.Rule.`unchecked call site`.id,
        // reason: `Tagged+Cyclic.Group.Static.Element.swift` is the
        // brand-newtype owner's domain-extension boundary for Tagged-
        // wrapped cyclic elements per [INFRA-103].
        Lint.Rule.`tagged extension public init`.id,
    ])
}
