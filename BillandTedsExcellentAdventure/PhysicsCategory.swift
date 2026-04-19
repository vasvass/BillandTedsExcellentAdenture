//  PhysicsCategory.swift
//  BillandTedsExcellentAdventure

import Foundation

struct PhysicsCategory {
    static let none:        UInt32 = 0
    static let player:      UInt32 = 0x1 << 0
    static let ground:      UInt32 = 0x1 << 1
    static let enemy:       UInt32 = 0x1 << 2
    static let collectible: UInt32 = 0x1 << 3
    static let phoneBooth:  UInt32 = 0x1 << 4
}
