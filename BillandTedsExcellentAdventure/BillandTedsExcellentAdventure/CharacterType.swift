//  CharacterType.swift
//  BillandTedsExcellentAdventure

import UIKit

enum CharacterType: String, CaseIterable {
    case bill = "Bill"
    case ted  = "Ted"

    var displayName: String {
        switch self {
        case .bill: return "Bill S. Preston, Esq."
        case .ted:  return "Ted \"Theodore\" Logan"
        }
    }

    var color: UIColor {
        switch self {
        case .bill: return .systemBlue
        case .ted:  return .systemRed
        }
    }

    // Vertical impulse applied on jump
    var jumpImpulse: CGFloat {
        switch self {
        case .bill: return 600   // higher jump
        case .ted:  return 500
        }
    }

    // Horizontal movement speed (points/s)
    var moveSpeed: CGFloat {
        switch self {
        case .bill: return 200
        case .ted:  return 260   // faster run
        }
    }

    var ability: String {
        switch self {
        case .bill: return "Air Guitar Shred"
        case .ted:  return "Bogus Distraction"
        }
    }

    var abilityDescription: String {
        switch self {
        case .bill: return "Stuns nearby enemies with a sonic wave"
        case .ted:  return "Confuses enemies, opening a path to escape"
        }
    }

    var jumpStars: String  { self == .bill ? "★★★★★" : "★★★☆☆" }
    var speedStars: String { self == .bill ? "★★★☆☆" : "★★★★★" }
}
