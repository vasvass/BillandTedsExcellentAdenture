//  SpriteFactory.swift
//  BillandTedsExcellentAdventure

import SpriteKit
import UIKit

enum SpriteFactory {

    // MARK: - Public API

    static func playerTexture(for type: CharacterType) -> SKTexture {
        let size = CGSize(width: 80, height: 120)
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            switch type {
            case .bill: drawBill(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
            case .ted:  drawTed (in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
            }
        }
        return SKTexture(image: img)
    }

    static func enemyTexture() -> SKTexture {
        let size = CGSize(width: 76, height: 100)
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawGuard(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func socratesTexture() -> SKTexture {
        let size = CGSize(width: 76, height: 116)
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawSocrates(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func groundTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawGround(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func platformTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawPlatform(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func skyTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawSky(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func mountainTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawMountains(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func columnTexture(width: CGFloat, height: CGFloat) -> SKTexture {
        let size = CGSize(width: width, height: height)
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawColumn(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func phoneBoothTexture() -> SKTexture {
        let size = CGSize(width: 104, height: 192)
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawPhoneBooth(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func teacherTexture() -> SKTexture {
        let size = CGSize(width: 72, height: 110)
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawTeacher(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func lockerBankTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawLockerBank(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func schoolFloorTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawSchoolFloor(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func chalkboardTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawChalkboard(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    static func schoolExteriorTexture(size: CGSize) -> SKTexture {
        let img = UIGraphicsImageRenderer(size: size).image { ctx in
            drawSchoolExterior(in: CGRect(origin: .zero, size: size), ctx: ctx.cgContext)
        }
        return SKTexture(image: img)
    }

    // MARK: - Bill

    private static func drawBill(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height

        // Shoes
        ctx.setFillColor(UIColor(red: 0.10, green: 0.08, blue: 0.08, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.08, y: h*0.88, width: w*0.33, height: h*0.12))
        ctx.fill(CGRect(x: w*0.59, y: h*0.88, width: w*0.33, height: h*0.12))

        // Jeans
        let jeans = UIColor(red: 0.18, green: 0.28, blue: 0.60, alpha: 1).cgColor
        ctx.setFillColor(jeans)
        ctx.fill(CGRect(x: w*0.14, y: h*0.50, width: w*0.30, height: h*0.40))
        ctx.fill(CGRect(x: w*0.56, y: h*0.50, width: w*0.30, height: h*0.40))
        // Jeans seam highlight
        ctx.setFillColor(UIColor(red: 0.24, green: 0.36, blue: 0.70, alpha: 0.5).cgColor)
        ctx.fill(CGRect(x: w*0.26, y: h*0.52, width: w*0.06, height: h*0.36))
        ctx.fill(CGRect(x: w*0.68, y: h*0.52, width: w*0.06, height: h*0.36))

        // Belt
        ctx.setFillColor(UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.12, y: h*0.478, width: w*0.76, height: h*0.055))
        // Belt buckle
        ctx.setFillColor(UIColor(red: 0.80, green: 0.68, blue: 0.20, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.43, y: h*0.480, width: w*0.14, height: h*0.048))

        // Blue shirt body
        let shirt = UIColor(red: 0.12, green: 0.36, blue: 0.88, alpha: 1).cgColor
        ctx.setFillColor(shirt)
        ctx.fill(CGRect(x: w*0.13, y: h*0.26, width: w*0.74, height: h*0.23))
        // Shirt collar V
        ctx.setFillColor(UIColor(red: 0.97, green: 0.96, blue: 0.94, alpha: 1).cgColor)
        let collar = CGMutablePath()
        collar.move(to: CGPoint(x: w*0.38, y: h*0.26))
        collar.addLine(to: CGPoint(x: w*0.50, y: h*0.35))
        collar.addLine(to: CGPoint(x: w*0.62, y: h*0.26))
        collar.closeSubpath()
        ctx.addPath(collar); ctx.fillPath()
        // Buttons
        ctx.setFillColor(UIColor(red: 0.88, green: 0.86, blue: 0.82, alpha: 1).cgColor)
        for i in 0..<3 {
            ctx.fillEllipse(in: CGRect(x: w*0.47, y: h*(0.30 + Double(i)*0.055),
                                       width: w*0.06, height: h*0.04))
        }
        // Arms
        ctx.setFillColor(shirt)
        ctx.fill(CGRect(x: w*0.00, y: h*0.28, width: w*0.15, height: h*0.22))
        ctx.fill(CGRect(x: w*0.85, y: h*0.28, width: w*0.15, height: h*0.22))
        // Hands
        let skin = UIColor(red: 0.95, green: 0.80, blue: 0.64, alpha: 1).cgColor
        ctx.setFillColor(skin)
        ctx.fillEllipse(in: CGRect(x: w*0.01, y: h*0.465, width: w*0.14, height: h*0.08))
        ctx.fillEllipse(in: CGRect(x: w*0.85, y: h*0.465, width: w*0.14, height: h*0.08))

        // Neck
        ctx.setFillColor(skin)
        ctx.fill(CGRect(x: w*0.40, y: h*0.17, width: w*0.20, height: h*0.12))

        // Head
        ctx.setFillColor(skin)
        ctx.fillEllipse(in: CGRect(x: w*0.17, y: h*0.03, width: w*0.66, height: h*0.22))

        // Blonde hair — wavy on top
        let hair = UIColor(red: 0.94, green: 0.80, blue: 0.22, alpha: 1).cgColor
        ctx.setFillColor(hair)
        let hairPath = CGMutablePath()
        hairPath.move(to: CGPoint(x: w*0.17, y: h*0.13))
        hairPath.addCurve(to: CGPoint(x: w*0.50, y: h*0.00),
                          control1: CGPoint(x: w*0.18, y: h*0.02),
                          control2: CGPoint(x: w*0.36, y: h*(-0.01)))
        hairPath.addCurve(to: CGPoint(x: w*0.83, y: h*0.13),
                          control1: CGPoint(x: w*0.64, y: h*(-0.01)),
                          control2: CGPoint(x: w*0.82, y: h*0.02))
        hairPath.addLine(to: CGPoint(x: w*0.83, y: h*0.09))
        hairPath.addCurve(to: CGPoint(x: w*0.17, y: h*0.09),
                          control1: CGPoint(x: w*0.72, y: h*(-0.02)),
                          control2: CGPoint(x: w*0.28, y: h*(-0.02)))
        hairPath.closeSubpath()
        ctx.addPath(hairPath); ctx.fillPath()
        // Sideburns
        ctx.fill(CGRect(x: w*0.16, y: h*0.10, width: w*0.07, height: h*0.08))
        ctx.fill(CGRect(x: w*0.77, y: h*0.10, width: w*0.07, height: h*0.08))

        // Eyes — white
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.28, y: h*0.10, width: w*0.15, height: h*0.07))
        ctx.fillEllipse(in: CGRect(x: w*0.57, y: h*0.10, width: w*0.15, height: h*0.07))
        // Irises — blue
        ctx.setFillColor(UIColor(red: 0.20, green: 0.45, blue: 0.90, alpha: 1).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.32, y: h*0.105, width: w*0.09, height: h*0.055))
        ctx.fillEllipse(in: CGRect(x: w*0.61, y: h*0.105, width: w*0.09, height: h*0.055))
        // Pupils
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.35, y: h*0.112, width: w*0.04, height: h*0.030))
        ctx.fillEllipse(in: CGRect(x: w*0.64, y: h*0.112, width: w*0.04, height: h*0.030))

        // Eyebrows
        ctx.setStrokeColor(UIColor(red: 0.80, green: 0.65, blue: 0.15, alpha: 1).cgColor)
        ctx.setLineWidth(2.0)
        ctx.move(to: CGPoint(x: w*0.26, y: h*0.095)); ctx.addLine(to: CGPoint(x: w*0.43, y: h*0.085)); ctx.strokePath()
        ctx.move(to: CGPoint(x: w*0.57, y: h*0.085)); ctx.addLine(to: CGPoint(x: w*0.74, y: h*0.095)); ctx.strokePath()

        // Grin
        ctx.setStrokeColor(UIColor(red: 0.55, green: 0.25, blue: 0.14, alpha: 1).cgColor)
        ctx.setLineWidth(1.5)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: w*0.36, y: h*0.19))
        ctx.addCurve(to: CGPoint(x: w*0.64, y: h*0.19),
                     control1: CGPoint(x: w*0.42, y: h*0.225),
                     control2: CGPoint(x: w*0.58, y: h*0.225))
        ctx.strokePath()

        // Guitar silhouette (small, at hip)
        ctx.setFillColor(UIColor(red: 0.55, green: 0.32, blue: 0.08, alpha: 0.9).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.76, y: h*0.36, width: w*0.20, height: h*0.14))
        ctx.fillEllipse(in: CGRect(x: w*0.79, y: h*0.28, width: w*0.14, height: h*0.11))
        ctx.setFillColor(UIColor(red: 0.35, green: 0.18, blue: 0.04, alpha: 0.9).cgColor)
        ctx.fill(CGRect(x: w*0.84, y: h*0.14, width: w*0.04, height: h*0.16))
    }

    // MARK: - Ted

    private static func drawTed(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height

        // Shoes
        ctx.setFillColor(UIColor(red: 0.06, green: 0.05, blue: 0.05, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.08, y: h*0.88, width: w*0.34, height: h*0.12))
        ctx.fill(CGRect(x: w*0.58, y: h*0.88, width: w*0.34, height: h*0.12))

        // Black jeans
        ctx.setFillColor(UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.14, y: h*0.50, width: w*0.29, height: h*0.40))
        ctx.fill(CGRect(x: w*0.57, y: h*0.50, width: w*0.29, height: h*0.40))

        // Dark red jacket body
        let jacket = UIColor(red: 0.58, green: 0.07, blue: 0.07, alpha: 1).cgColor
        ctx.setFillColor(jacket)
        ctx.fill(CGRect(x: w*0.12, y: h*0.24, width: w*0.76, height: h*0.28))

        // Jacket lapels — white shirt peek
        ctx.setFillColor(UIColor.white.cgColor)
        let lapelL = CGMutablePath()
        lapelL.move(to: CGPoint(x: w*0.36, y: h*0.24))
        lapelL.addLine(to: CGPoint(x: w*0.50, y: h*0.42))
        lapelL.addLine(to: CGPoint(x: w*0.50, y: h*0.24))
        lapelL.closeSubpath()
        ctx.addPath(lapelL); ctx.fillPath()
        let lapelR = CGMutablePath()
        lapelR.move(to: CGPoint(x: w*0.64, y: h*0.24))
        lapelR.addLine(to: CGPoint(x: w*0.50, y: h*0.42))
        lapelR.addLine(to: CGPoint(x: w*0.50, y: h*0.24))
        lapelR.closeSubpath()
        ctx.addPath(lapelR); ctx.fillPath()
        // lapel outline
        ctx.setStrokeColor(UIColor(red: 0.40, green: 0.04, blue: 0.04, alpha: 1).cgColor)
        ctx.setLineWidth(1.0)
        ctx.addPath(lapelL); ctx.strokePath()
        ctx.addPath(lapelR); ctx.strokePath()

        // Belt
        ctx.setFillColor(UIColor(red: 0.14, green: 0.10, blue: 0.06, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.12, y: h*0.478, width: w*0.76, height: h*0.052))

        // Arms
        ctx.setFillColor(jacket)
        ctx.fill(CGRect(x: w*0.00, y: h*0.26, width: w*0.14, height: h*0.24))
        ctx.fill(CGRect(x: w*0.86, y: h*0.26, width: w*0.14, height: h*0.24))
        let skin = UIColor(red: 0.88, green: 0.72, blue: 0.56, alpha: 1).cgColor
        ctx.setFillColor(skin)
        ctx.fillEllipse(in: CGRect(x: w*0.01, y: h*0.460, width: w*0.13, height: h*0.08))
        ctx.fillEllipse(in: CGRect(x: w*0.86, y: h*0.460, width: w*0.13, height: h*0.08))

        // Neck
        ctx.setFillColor(skin)
        ctx.fill(CGRect(x: w*0.40, y: h*0.16, width: w*0.20, height: h*0.11))

        // Head
        ctx.fillEllipse(in: CGRect(x: w*0.16, y: h*0.02, width: w*0.68, height: h*0.22))

        // Dark thick hair
        ctx.setFillColor(UIColor(red: 0.12, green: 0.08, blue: 0.06, alpha: 1).cgColor)
        let hairPath = CGMutablePath()
        hairPath.move(to: CGPoint(x: w*0.16, y: h*0.14))
        hairPath.addCurve(to: CGPoint(x: w*0.50, y: h*(-0.02)),
                          control1: CGPoint(x: w*0.18, y: h*0.00),
                          control2: CGPoint(x: w*0.34, y: h*(-0.03)))
        hairPath.addCurve(to: CGPoint(x: w*0.84, y: h*0.14),
                          control1: CGPoint(x: w*0.66, y: h*(-0.03)),
                          control2: CGPoint(x: w*0.82, y: h*0.00))
        hairPath.addLine(to: CGPoint(x: w*0.84, y: h*0.10))
        hairPath.addCurve(to: CGPoint(x: w*0.16, y: h*0.10),
                          control1: CGPoint(x: w*0.74, y: h*(-0.04)),
                          control2: CGPoint(x: w*0.26, y: h*(-0.04)))
        hairPath.closeSubpath()
        ctx.addPath(hairPath); ctx.fillPath()
        // Sideburns
        ctx.fill(CGRect(x: w*0.14, y: h*0.10, width: w*0.09, height: h*0.11))
        ctx.fill(CGRect(x: w*0.77, y: h*0.10, width: w*0.09, height: h*0.11))

        // Eyes — white
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.27, y: h*0.10, width: w*0.15, height: h*0.07))
        ctx.fillEllipse(in: CGRect(x: w*0.58, y: h*0.10, width: w*0.15, height: h*0.07))
        // Brown irises
        ctx.setFillColor(UIColor(red: 0.30, green: 0.18, blue: 0.06, alpha: 1).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.31, y: h*0.105, width: w*0.09, height: h*0.055))
        ctx.fillEllipse(in: CGRect(x: w*0.62, y: h*0.105, width: w*0.09, height: h*0.055))
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.34, y: h*0.112, width: w*0.04, height: h*0.030))
        ctx.fillEllipse(in: CGRect(x: w*0.65, y: h*0.112, width: w*0.04, height: h*0.030))

        // Dark eyebrows
        ctx.setStrokeColor(UIColor(red: 0.10, green: 0.06, blue: 0.04, alpha: 1).cgColor)
        ctx.setLineWidth(2.5)
        ctx.move(to: CGPoint(x: w*0.25, y: h*0.090)); ctx.addLine(to: CGPoint(x: w*0.42, y: h*0.082)); ctx.strokePath()
        ctx.move(to: CGPoint(x: w*0.58, y: h*0.082)); ctx.addLine(to: CGPoint(x: w*0.75, y: h*0.090)); ctx.strokePath()

        // Goofy grin
        ctx.setStrokeColor(UIColor(red: 0.50, green: 0.22, blue: 0.12, alpha: 1).cgColor)
        ctx.setLineWidth(1.5)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: w*0.35, y: h*0.188))
        ctx.addCurve(to: CGPoint(x: w*0.65, y: h*0.188),
                     control1: CGPoint(x: w*0.41, y: h*0.225),
                     control2: CGPoint(x: w*0.59, y: h*0.225))
        ctx.strokePath()
    }

    // MARK: - Guard (Roman Soldier)

    private static func drawGuard(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let bronze  = UIColor(red: 0.72, green: 0.56, blue: 0.18, alpha: 1).cgColor
        let darkBronze = UIColor(red: 0.48, green: 0.36, blue: 0.08, alpha: 1).cgColor
        let cape    = UIColor(red: 0.72, green: 0.07, blue: 0.05, alpha: 1).cgColor
        let skin    = UIColor(red: 0.88, green: 0.72, blue: 0.56, alpha: 1).cgColor
        let plume   = UIColor(red: 0.85, green: 0.10, blue: 0.08, alpha: 1).cgColor
        let leather = UIColor(red: 0.52, green: 0.36, blue: 0.14, alpha: 1).cgColor

        // Spear
        ctx.setFillColor(UIColor(red: 0.60, green: 0.48, blue: 0.12, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.86, y: h*0.05, width: w*0.05, height: h*0.82))
        ctx.setFillColor(UIColor(red: 0.75, green: 0.75, blue: 0.80, alpha: 1).cgColor)
        let tip = CGMutablePath()
        tip.move(to: CGPoint(x: w*0.835, y: h*0.05))
        tip.addLine(to: CGPoint(x: w*0.910, y: h*0.05))
        tip.addLine(to: CGPoint(x: w*0.873, y: h*(-0.02)))
        tip.closeSubpath()
        ctx.addPath(tip); ctx.fillPath()

        // Sandal legs (skin)
        ctx.setFillColor(skin)
        ctx.fill(CGRect(x: w*0.18, y: h*0.54, width: w*0.25, height: h*0.40))
        ctx.fill(CGRect(x: w*0.57, y: h*0.54, width: w*0.25, height: h*0.40))
        // Sandal straps
        ctx.setFillColor(leather)
        for i in 0..<5 {
            let yy = h * (0.56 + Double(i) * 0.072)
            ctx.fill(CGRect(x: w*0.12, y: yy, width: w*0.30, height: h*0.018))
            ctx.fill(CGRect(x: w*0.56, y: yy, width: w*0.30, height: h*0.018))
        }
        // Sandal soles
        ctx.setFillColor(UIColor(red: 0.38, green: 0.25, blue: 0.10, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.10, y: h*0.92, width: w*0.34, height: h*0.06))
        ctx.fill(CGRect(x: w*0.56, y: h*0.92, width: w*0.34, height: h*0.06))

        // Pteruges (leather skirt strips)
        ctx.setFillColor(leather)
        ctx.fill(CGRect(x: w*0.14, y: h*0.46, width: w*0.72, height: h*0.14))
        ctx.setFillColor(UIColor(red: 0.42, green: 0.28, blue: 0.08, alpha: 1).cgColor)
        for i in 0..<6 {
            let xx = w * (0.15 + Double(i) * 0.116)
            ctx.fill(CGRect(x: xx, y: h*0.48, width: w*0.09, height: h*0.12))
        }

        // Cape (behind)
        ctx.setFillColor(cape)
        ctx.fill(CGRect(x: w*0.68, y: h*0.22, width: w*0.22, height: h*0.44))

        // Breastplate
        ctx.setFillColor(bronze)
        let breast = CGMutablePath()
        breast.move(to: CGPoint(x: w*0.14, y: h*0.26))
        breast.addLine(to: CGPoint(x: w*0.86, y: h*0.26))
        breast.addLine(to: CGPoint(x: w*0.82, y: h*0.50))
        breast.addLine(to: CGPoint(x: w*0.50, y: h*0.54))
        breast.addLine(to: CGPoint(x: w*0.18, y: h*0.50))
        breast.closeSubpath()
        ctx.addPath(breast); ctx.fillPath()
        // Muscle line
        ctx.setStrokeColor(darkBronze)
        ctx.setLineWidth(1.2)
        ctx.move(to: CGPoint(x: w*0.50, y: h*0.26))
        ctx.addLine(to: CGPoint(x: w*0.50, y: h*0.50))
        ctx.strokePath()
        // Chest highlight
        ctx.setFillColor(UIColor(red: 0.90, green: 0.78, blue: 0.38, alpha: 0.35).cgColor)
        ctx.fill(CGRect(x: w*0.16, y: h*0.27, width: w*0.30, height: h*0.10))

        // Pauldrons (shoulder plates)
        ctx.setFillColor(bronze)
        ctx.fillEllipse(in: CGRect(x: w*0.02, y: h*0.22, width: w*0.18, height: h*0.10))
        ctx.fillEllipse(in: CGRect(x: w*0.80, y: h*0.22, width: w*0.18, height: h*0.10))

        // Arms
        ctx.setFillColor(bronze)
        ctx.fill(CGRect(x: w*0.02, y: h*0.28, width: w*0.14, height: h*0.20))
        ctx.fill(CGRect(x: w*0.84, y: h*0.28, width: w*0.14, height: h*0.20))
        ctx.setFillColor(skin)
        ctx.fillEllipse(in: CGRect(x: w*0.02, y: h*0.45, width: w*0.14, height: h*0.08))
        ctx.fillEllipse(in: CGRect(x: w*0.84, y: h*0.45, width: w*0.14, height: h*0.08))

        // Neck
        ctx.setFillColor(skin)
        ctx.fill(CGRect(x: w*0.40, y: h*0.16, width: w*0.20, height: h*0.12))

        // Helmet body
        ctx.setFillColor(bronze)
        let helm = CGMutablePath()
        helm.move(to: CGPoint(x: w*0.14, y: h*0.16))
        helm.addCurve(to: CGPoint(x: w*0.86, y: h*0.16),
                      control1: CGPoint(x: w*0.14, y: h*(-0.06)),
                      control2: CGPoint(x: w*0.86, y: h*(-0.06)))
        helm.addLine(to: CGPoint(x: w*0.86, y: h*0.24))
        helm.addLine(to: CGPoint(x: w*0.14, y: h*0.24))
        helm.closeSubpath()
        ctx.addPath(helm); ctx.fillPath()
        // Helmet shine
        ctx.setFillColor(UIColor(red: 0.90, green: 0.78, blue: 0.36, alpha: 0.4).cgColor)
        ctx.fill(CGRect(x: w*0.18, y: h*0.04, width: w*0.22, height: h*0.08))

        // Cheekguards
        ctx.setFillColor(bronze)
        ctx.fill(CGRect(x: w*0.14, y: h*0.14, width: w*0.12, height: h*0.14))
        ctx.fill(CGRect(x: w*0.74, y: h*0.14, width: w*0.12, height: h*0.14))
        // Nose guard
        ctx.fill(CGRect(x: w*0.46, y: h*0.14, width: w*0.08, height: h*0.10))

        // Face
        ctx.setFillColor(skin)
        ctx.fillEllipse(in: CGRect(x: w*0.24, y: h*0.10, width: w*0.52, height: h*0.18))

        // Eyes — stern
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.31, y: h*0.125, width: w*0.12, height: h*0.055))
        ctx.fillEllipse(in: CGRect(x: w*0.57, y: h*0.125, width: w*0.12, height: h*0.055))
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.36, y: h*0.132, width: w*0.04, height: h*0.025))
        ctx.fillEllipse(in: CGRect(x: w*0.62, y: h*0.132, width: w*0.04, height: h*0.025))

        // Stern mouth
        ctx.setStrokeColor(UIColor(red: 0.40, green: 0.18, blue: 0.10, alpha: 1).cgColor)
        ctx.setLineWidth(1.5)
        ctx.move(to: CGPoint(x: w*0.35, y: h*0.23))
        ctx.addLine(to: CGPoint(x: w*0.65, y: h*0.23))
        ctx.strokePath()

        // Plume — red crest
        ctx.setFillColor(plume)
        let plumeP = CGMutablePath()
        plumeP.move(to: CGPoint(x: w*0.38, y: h*0.02))
        plumeP.addCurve(to: CGPoint(x: w*0.62, y: h*0.02),
                        control1: CGPoint(x: w*0.40, y: h*(-0.10)),
                        control2: CGPoint(x: w*0.60, y: h*(-0.10)))
        plumeP.addLine(to: CGPoint(x: w*0.60, y: h*0.05))
        plumeP.addLine(to: CGPoint(x: w*0.40, y: h*0.05))
        plumeP.closeSubpath()
        ctx.addPath(plumeP); ctx.fillPath()
    }

    // MARK: - Socrates

    private static func drawSocrates(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let skin   = UIColor(red: 0.88, green: 0.74, blue: 0.60, alpha: 1).cgColor
        let toga   = UIColor(red: 0.97, green: 0.96, blue: 0.92, alpha: 1).cgColor
        let togaShadow = UIColor(red: 0.80, green: 0.78, blue: 0.74, alpha: 1).cgColor
        let beard  = UIColor(red: 0.72, green: 0.70, blue: 0.66, alpha: 1).cgColor
        let laurel = UIColor(red: 0.22, green: 0.56, blue: 0.16, alpha: 1).cgColor

        // Sandals
        ctx.setFillColor(UIColor(red: 0.45, green: 0.30, blue: 0.12, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.10, y: h*0.92, width: w*0.30, height: h*0.06))
        ctx.fill(CGRect(x: w*0.60, y: h*0.92, width: w*0.30, height: h*0.06))

        // Toga — main drape
        ctx.setFillColor(toga)
        let togaPath = CGMutablePath()
        togaPath.move(to: CGPoint(x: w*0.07, y: h*0.28))
        togaPath.addLine(to: CGPoint(x: w*0.93, y: h*0.28))
        togaPath.addLine(to: CGPoint(x: w*0.86, y: h*0.94))
        togaPath.addLine(to: CGPoint(x: w*0.14, y: h*0.94))
        togaPath.closeSubpath()
        ctx.addPath(togaPath); ctx.fillPath()

        // Toga fold shading
        ctx.setFillColor(togaShadow)
        ctx.fill(CGRect(x: w*0.07, y: h*0.28, width: w*0.24, height: h*0.55))

        // Toga fold lines
        ctx.setStrokeColor(UIColor(red: 0.65, green: 0.63, blue: 0.60, alpha: 0.7).cgColor)
        ctx.setLineWidth(1.0)
        for i in 0..<3 {
            let xStart = w * (0.28 + Double(i) * 0.18)
            ctx.move(to: CGPoint(x: xStart, y: h*0.32))
            ctx.addCurve(to: CGPoint(x: xStart - w*0.06, y: h*0.88),
                         control1: CGPoint(x: xStart - w*0.04, y: h*0.55),
                         control2: CGPoint(x: xStart - w*0.08, y: h*0.72))
            ctx.strokePath()
        }

        // Rope belt
        ctx.setFillColor(UIColor(red: 0.62, green: 0.48, blue: 0.24, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.10, y: h*0.48, width: w*0.80, height: h*0.04))

        // Neck
        ctx.setFillColor(skin)
        ctx.fill(CGRect(x: w*0.40, y: h*0.19, width: w*0.20, height: h*0.12))

        // Head — bald, round
        ctx.setFillColor(skin)
        ctx.fillEllipse(in: CGRect(x: w*0.18, y: h*0.03, width: w*0.64, height: h*0.24))

        // Beard — full and grey
        ctx.setFillColor(beard)
        let beardPath = CGMutablePath()
        beardPath.move(to: CGPoint(x: w*0.20, y: h*0.16))
        beardPath.addCurve(to: CGPoint(x: w*0.80, y: h*0.16),
                           control1: CGPoint(x: w*0.16, y: h*0.30),
                           control2: CGPoint(x: w*0.84, y: h*0.30))
        beardPath.addLine(to: CGPoint(x: w*0.64, y: h*0.36))
        beardPath.addLine(to: CGPoint(x: w*0.50, y: h*0.40))
        beardPath.addLine(to: CGPoint(x: w*0.36, y: h*0.36))
        beardPath.closeSubpath()
        ctx.addPath(beardPath); ctx.fillPath()
        // Beard texture lines
        ctx.setStrokeColor(UIColor(red: 0.55, green: 0.53, blue: 0.50, alpha: 0.6).cgColor)
        ctx.setLineWidth(0.8)
        for i in 0..<5 {
            let bx = w * (0.30 + Double(i) * 0.08)
            ctx.move(to: CGPoint(x: bx, y: h*0.20))
            ctx.addLine(to: CGPoint(x: bx - w*0.02, y: h*0.34))
            ctx.strokePath()
        }

        // Moustache
        ctx.setFillColor(UIColor(red: 0.60, green: 0.58, blue: 0.54, alpha: 1).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.30, y: h*0.19, width: w*0.40, height: h*0.058))

        // Eyes — wise
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.27, y: h*0.08, width: w*0.16, height: h*0.072))
        ctx.fillEllipse(in: CGRect(x: w*0.57, y: h*0.08, width: w*0.16, height: h*0.072))
        ctx.setFillColor(UIColor(red: 0.22, green: 0.15, blue: 0.08, alpha: 1).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.31, y: h*0.085, width: w*0.09, height: h*0.055))
        ctx.fillEllipse(in: CGRect(x: w*0.61, y: h*0.085, width: w*0.09, height: h*0.055))
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.340, y: h*0.092, width: w*0.040, height: h*0.032))
        ctx.fillEllipse(in: CGRect(x: w*0.645, y: h*0.092, width: w*0.040, height: h*0.032))

        // Bushy grey eyebrows
        ctx.setStrokeColor(beard)
        ctx.setLineWidth(3.0)
        ctx.move(to: CGPoint(x: w*0.24, y: h*0.075)); ctx.addLine(to: CGPoint(x: w*0.43, y: h*0.068)); ctx.strokePath()
        ctx.move(to: CGPoint(x: w*0.57, y: h*0.068)); ctx.addLine(to: CGPoint(x: w*0.76, y: h*0.075)); ctx.strokePath()

        // Laurel wreath
        ctx.setFillColor(laurel)
        let leafCount = 10
        for i in 0..<leafCount {
            let angle = Double(i) * (.pi / Double(leafCount)) - .pi * 0.08
            let radius = w * 0.30
            let cx = w * 0.50 + cos(angle) * radius
            let cy = h * 0.07 - sin(angle) * h * 0.10
            let leafRect = CGRect(x: cx - w*0.065, y: cy - h*0.038, width: w*0.13, height: h*0.055)
            ctx.saveGState()
            ctx.translateBy(x: leafRect.midX, y: leafRect.midY)
            ctx.rotate(by: angle + .pi * 0.5)
            ctx.fillEllipse(in: CGRect(x: -w*0.065, y: -h*0.028, width: w*0.13, height: h*0.055))
            ctx.restoreGState()
        }
        // Wreath band
        ctx.setStrokeColor(UIColor(red: 0.15, green: 0.42, blue: 0.10, alpha: 0.8).cgColor)
        ctx.setLineWidth(2.0)
        ctx.beginPath()
        ctx.addArc(center: CGPoint(x: w*0.50, y: h*0.07),
                   radius: w*0.30, startAngle: .pi * 1.06, endAngle: .pi * 0.06, clockwise: true)
        ctx.strokePath()
    }

    // MARK: - Ground

    private static func drawGround(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height

        // Base fill
        ctx.setFillColor(UIColor(red: 0.82, green: 0.76, blue: 0.62, alpha: 1).cgColor)
        ctx.fill(r)

        // Stone blocks (deterministic pattern)
        let blockH = h * 0.48
        let blockWidths: [CGFloat] = [72, 58, 80, 64, 76, 56, 88, 60, 70, 82, 66, 74]
        let colors: [CGColor] = [
            UIColor(red: 0.78, green: 0.72, blue: 0.58, alpha: 1).cgColor,
            UIColor(red: 0.86, green: 0.80, blue: 0.66, alpha: 1).cgColor,
            UIColor(red: 0.74, green: 0.68, blue: 0.54, alpha: 1).cgColor,
            UIColor(red: 0.80, green: 0.74, blue: 0.60, alpha: 1).cgColor
        ]

        for row in 0..<2 {
            var x: CGFloat = row == 1 ? 32 : 0
            var idx = 0
            while x < w {
                let bw = blockWidths[idx % blockWidths.count]
                ctx.setFillColor(colors[idx % colors.count])
                ctx.fill(CGRect(x: x + 1, y: CGFloat(row) * blockH + 1, width: bw - 2, height: blockH - 2))
                x += bw; idx += 1
            }
        }

        // Top highlight strip
        ctx.setFillColor(UIColor(red: 0.94, green: 0.90, blue: 0.78, alpha: 0.9).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: 4))

        // Subtle crack marks
        ctx.setStrokeColor(UIColor(red: 0.55, green: 0.50, blue: 0.38, alpha: 0.45).cgColor)
        ctx.setLineWidth(1)
        let crackXs: [CGFloat] = [w*0.12, w*0.28, w*0.44, w*0.60, w*0.76, w*0.90]
        for cx in crackXs {
            ctx.move(to: CGPoint(x: cx, y: h*0.10))
            ctx.addLine(to: CGPoint(x: cx + 10, y: h*0.55))
            ctx.strokePath()
        }
    }

    // MARK: - Platform

    private static func drawPlatform(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height

        // Main stone
        ctx.setFillColor(UIColor(red: 0.90, green: 0.86, blue: 0.74, alpha: 1).cgColor)
        ctx.fill(r)

        // Top face highlight
        ctx.setFillColor(UIColor(red: 0.97, green: 0.94, blue: 0.84, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: h * 0.32))

        // Bottom shadow
        ctx.setFillColor(UIColor(red: 0.68, green: 0.62, blue: 0.50, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: h * 0.70, width: w, height: h * 0.30))

        // Vertical joints every 60px
        ctx.setStrokeColor(UIColor(red: 0.58, green: 0.52, blue: 0.40, alpha: 0.45).cgColor)
        ctx.setLineWidth(1)
        var x: CGFloat = 60
        while x < w { ctx.move(to: CGPoint(x: x, y: 0)); ctx.addLine(to: CGPoint(x: x, y: h)); ctx.strokePath(); x += 60 }
    }

    // MARK: - Sky

    private static func drawSky(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let colors: [CGColor] = [
            UIColor(red: 0.14, green: 0.34, blue: 0.76, alpha: 1).cgColor,
            UIColor(red: 0.30, green: 0.56, blue: 0.88, alpha: 1).cgColor,
            UIColor(red: 0.54, green: 0.76, blue: 0.95, alpha: 1).cgColor,
            UIColor(red: 0.82, green: 0.88, blue: 0.80, alpha: 1).cgColor,
            UIColor(red: 0.94, green: 0.90, blue: 0.76, alpha: 1).cgColor
        ]
        let locs: [CGFloat] = [0, 0.28, 0.58, 0.82, 1.0]
        guard let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors as CFArray,
                                    locations: locs) else {
            ctx.setFillColor(UIColor(red: 0.42, green: 0.66, blue: 0.92, alpha: 1).cgColor)
            ctx.fill(r)
            return
        }
        ctx.drawLinearGradient(grad,
                               start: CGPoint(x: 0, y: 0),
                               end:   CGPoint(x: 0, y: h),
                               options: [])
        // Horizon haze
        let hazeColors: [CGColor] = [
            UIColor(red: 0.94, green: 0.90, blue: 0.76, alpha: 0.0).cgColor,
            UIColor(red: 0.94, green: 0.90, blue: 0.76, alpha: 0.55).cgColor
        ]
        let hazeLocs: [CGFloat] = [0, 1]
        if let hazeGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: hazeColors as CFArray, locations: hazeLocs) {
            ctx.drawLinearGradient(hazeGrad,
                                   start: CGPoint(x: 0, y: h * 0.72),
                                   end:   CGPoint(x: 0, y: h),
                                   options: [])
        }
        _ = w // suppress unused warning
    }

    // MARK: - Mountains

    private static func drawMountains(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height

        // Far mountains (pale blue)
        ctx.setFillColor(UIColor(red: 0.58, green: 0.68, blue: 0.82, alpha: 0.45).cgColor)
        let farMtns = CGMutablePath()
        farMtns.move(to: CGPoint(x: 0, y: h))
        let farPts: [(CGFloat, CGFloat)] = [(0,0.55),(0.08,0.22),(0.20,0.40),(0.30,0.12),(0.42,0.38),(0.54,0.08),(0.66,0.30),(0.78,0.18),(0.88,0.35),(1.0,0.50),(1.0,1.0)]
        for p in farPts { farMtns.addLine(to: CGPoint(x: w*p.0, y: h*p.1)) }
        farMtns.closeSubpath()
        ctx.addPath(farMtns); ctx.fillPath()

        // Mid mountains (warm stone)
        ctx.setFillColor(UIColor(red: 0.70, green: 0.64, blue: 0.52, alpha: 0.60).cgColor)
        let midMtns = CGMutablePath()
        midMtns.move(to: CGPoint(x: 0, y: h))
        let midPts: [(CGFloat, CGFloat)] = [(0,0.65),(0.06,0.45),(0.14,0.62),(0.24,0.32),(0.36,0.55),(0.46,0.28),(0.58,0.48),(0.68,0.35),(0.80,0.52),(0.90,0.40),(1.0,0.60),(1.0,1.0)]
        for p in midPts { midMtns.addLine(to: CGPoint(x: w*p.0, y: h*p.1)) }
        midMtns.closeSubpath()
        ctx.addPath(midMtns); ctx.fillPath()

        // Snow/highlight on far peaks
        ctx.setFillColor(UIColor.white.withAlphaComponent(0.30).cgColor)
        let snowPeaks: [(CGFloat, CGFloat, CGFloat)] = [(0.08,0.22,0.06),(0.30,0.12,0.08),(0.54,0.08,0.07),(0.78,0.18,0.06)]
        for p in snowPeaks {
            let snowPath = CGMutablePath()
            snowPath.move(to: CGPoint(x: w*(p.0 - p.2), y: h*(p.1 + p.2 * 0.8)))
            snowPath.addLine(to: CGPoint(x: w*p.0, y: h*p.1))
            snowPath.addLine(to: CGPoint(x: w*(p.0 + p.2), y: h*(p.1 + p.2 * 0.8)))
            snowPath.closeSubpath()
            ctx.addPath(snowPath); ctx.fillPath()
        }
    }

    // MARK: - Doric Column

    private static func drawColumn(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let marble  = UIColor(red: 0.94, green: 0.91, blue: 0.84, alpha: 1).cgColor
        let shadow  = UIColor(red: 0.72, green: 0.68, blue: 0.58, alpha: 1).cgColor
        let midTone = UIColor(red: 0.86, green: 0.82, blue: 0.72, alpha: 1).cgColor

        // Stylobate (base slab)
        ctx.setFillColor(shadow)
        ctx.fill(CGRect(x: 0, y: h*0.92, width: w, height: h*0.08))
        ctx.setFillColor(marble)
        ctx.fill(CGRect(x: 0, y: h*0.89, width: w, height: h*0.05))

        // Shaft
        ctx.setFillColor(marble)
        ctx.fill(CGRect(x: w*0.12, y: h*0.12, width: w*0.76, height: h*0.79))

        // Fluting (vertical shadow lines)
        ctx.setFillColor(shadow)
        let fluteCount = 8
        let shaftLeft = w * 0.12
        let shaftW = w * 0.76
        for i in 0..<fluteCount {
            let fx = shaftLeft + shaftW * CGFloat(i) / CGFloat(fluteCount) + shaftW / CGFloat(fluteCount * 2)
            ctx.fill(CGRect(x: fx, y: h*0.12, width: 1.5, height: h*0.79))
        }
        // Shaft highlight left
        ctx.setFillColor(UIColor(red: 0.98, green: 0.96, blue: 0.90, alpha: 0.8).cgColor)
        ctx.fill(CGRect(x: w*0.14, y: h*0.12, width: w*0.12, height: h*0.79))

        // Entasis (slight middle taper) — shadow right edge
        ctx.setFillColor(midTone)
        ctx.fill(CGRect(x: w*0.78, y: h*0.12, width: w*0.10, height: h*0.79))

        // Echinus (capital cushion)
        ctx.setFillColor(marble)
        let echinus = CGMutablePath()
        echinus.move(to: CGPoint(x: w*0.10, y: h*0.12))
        echinus.addCurve(to: CGPoint(x: w*0.90, y: h*0.12),
                         control1: CGPoint(x: w*0.14, y: h*0.04),
                         control2: CGPoint(x: w*0.86, y: h*0.04))
        echinus.addLine(to: CGPoint(x: w*0.88, y: h*0.12))
        echinus.addLine(to: CGPoint(x: w*0.12, y: h*0.12))
        echinus.closeSubpath()
        ctx.addPath(echinus); ctx.fillPath()

        // Abacus (flat top slab)
        ctx.setFillColor(shadow)
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: h*0.04))
        ctx.setFillColor(marble)
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: h*0.03))
    }

    // MARK: - Phone Booth (TARDIS-style)

    private static func drawPhoneBooth(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let blue   = UIColor(red: 0.04, green: 0.22, blue: 0.60, alpha: 1).cgColor
        let darkB  = UIColor(red: 0.02, green: 0.14, blue: 0.40, alpha: 1).cgColor
        let panel  = UIColor(red: 0.06, green: 0.30, blue: 0.72, alpha: 0.85).cgColor
        let glowW  = UIColor(red: 0.90, green: 0.96, blue: 1.00, alpha: 1).cgColor

        // Main box body
        ctx.setFillColor(blue)
        ctx.fill(CGRect(x: w*0.06, y: h*0.06, width: w*0.88, height: h*0.90))

        // Roof lamp box
        ctx.setFillColor(darkB)
        ctx.fill(CGRect(x: w*0.20, y: h*0.00, width: w*0.60, height: h*0.08))
        ctx.setFillColor(glowW)
        ctx.fill(CGRect(x: w*0.30, y: h*0.01, width: w*0.40, height: h*0.05))

        // Corner posts
        ctx.setFillColor(darkB)
        ctx.fill(CGRect(x: w*0.06, y: h*0.06, width: w*0.08, height: h*0.90))
        ctx.fill(CGRect(x: w*0.86, y: h*0.06, width: w*0.08, height: h*0.90))

        // Horizontal rails
        ctx.fill(CGRect(x: w*0.06, y: h*0.22, width: w*0.88, height: h*0.025))
        ctx.fill(CGRect(x: w*0.06, y: h*0.60, width: w*0.88, height: h*0.025))
        ctx.fill(CGRect(x: w*0.06, y: h*0.92, width: w*0.88, height: h*0.025))

        // Top sign panel
        ctx.setFillColor(panel)
        ctx.fill(CGRect(x: w*0.14, y: h*0.08, width: w*0.72, height: h*0.13))
        ctx.setFillColor(glowW)

        // Window panes (2x2 grid, upper section)
        let panes: [(CGFloat, CGFloat)] = [(0.15, 0.25), (0.55, 0.25), (0.15, 0.41), (0.55, 0.41)]
        for (px, py) in panes {
            ctx.setFillColor(panel)
            ctx.fill(CGRect(x: w*px, y: h*py, width: w*0.30, height: h*0.14))
            ctx.setFillColor(UIColor(red: 0.70, green: 0.88, blue: 1.00, alpha: 0.50).cgColor)
            ctx.fill(CGRect(x: w*px + 2, y: h*py + 2, width: w*0.30 - 4, height: h*0.14 - 4))
        }

        // Door panels (lower)
        ctx.setFillColor(darkB)
        ctx.fill(CGRect(x: w*0.14, y: h*0.62, width: w*0.33, height: h*0.28))
        ctx.fill(CGRect(x: w*0.53, y: h*0.62, width: w*0.33, height: h*0.28))
        ctx.setFillColor(panel)
        ctx.fill(CGRect(x: w*0.17, y: h*0.65, width: w*0.27, height: h*0.22))
        ctx.fill(CGRect(x: w*0.56, y: h*0.65, width: w*0.27, height: h*0.22))

        // Door handle
        ctx.setFillColor(UIColor(red: 0.80, green: 0.70, blue: 0.20, alpha: 1).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.48, y: h*0.75, width: w*0.05, height: h*0.04))

        // "POLICE BOX" text sim — white strips
        ctx.setFillColor(glowW)
        ctx.fill(CGRect(x: w*0.16, y: h*0.10, width: w*0.68, height: h*0.03))
        ctx.fill(CGRect(x: w*0.16, y: h*0.15, width: w*0.68, height: h*0.03))
    }

    // MARK: - Teacher (Mr. Ryan)

    private static func drawTeacher(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let skin    = UIColor(red: 0.90, green: 0.76, blue: 0.60, alpha: 1).cgColor
        let suit    = UIColor(red: 0.32, green: 0.28, blue: 0.22, alpha: 1).cgColor
        let shirtW  = UIColor(red: 0.94, green: 0.93, blue: 0.90, alpha: 1).cgColor
        let tie     = UIColor(red: 0.60, green: 0.14, blue: 0.14, alpha: 1).cgColor
        let hair    = UIColor(red: 0.40, green: 0.32, blue: 0.22, alpha: 1).cgColor
        let shoe    = UIColor(red: 0.14, green: 0.10, blue: 0.08, alpha: 1).cgColor
        let paper   = UIColor(red: 0.97, green: 0.96, blue: 0.88, alpha: 1).cgColor

        // Shoes
        ctx.setFillColor(shoe)
        ctx.fill(CGRect(x: w*0.10, y: h*0.90, width: w*0.30, height: h*0.10))
        ctx.fill(CGRect(x: w*0.60, y: h*0.90, width: w*0.30, height: h*0.10))

        // Trousers (dark grey)
        ctx.setFillColor(UIColor(red: 0.28, green: 0.26, blue: 0.24, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.16, y: h*0.52, width: w*0.27, height: h*0.40))
        ctx.fill(CGRect(x: w*0.57, y: h*0.52, width: w*0.27, height: h*0.40))

        // Suit jacket body
        ctx.setFillColor(suit)
        ctx.fill(CGRect(x: w*0.13, y: h*0.27, width: w*0.74, height: h*0.28))

        // White shirt / lapels
        ctx.setFillColor(shirtW)
        let lapelL = CGMutablePath()
        lapelL.move(to: CGPoint(x: w*0.35, y: h*0.27))
        lapelL.addLine(to: CGPoint(x: w*0.50, y: h*0.44))
        lapelL.addLine(to: CGPoint(x: w*0.50, y: h*0.27))
        lapelL.closeSubpath()
        ctx.addPath(lapelL); ctx.fillPath()
        let lapelR = CGMutablePath()
        lapelR.move(to: CGPoint(x: w*0.65, y: h*0.27))
        lapelR.addLine(to: CGPoint(x: w*0.50, y: h*0.44))
        lapelR.addLine(to: CGPoint(x: w*0.50, y: h*0.27))
        lapelR.closeSubpath()
        ctx.addPath(lapelR); ctx.fillPath()

        // Tie
        ctx.setFillColor(tie)
        let tiePath = CGMutablePath()
        tiePath.move(to: CGPoint(x: w*0.44, y: h*0.27))
        tiePath.addLine(to: CGPoint(x: w*0.56, y: h*0.27))
        tiePath.addLine(to: CGPoint(x: w*0.54, y: h*0.50))
        tiePath.addLine(to: CGPoint(x: w*0.50, y: h*0.56))
        tiePath.addLine(to: CGPoint(x: w*0.46, y: h*0.50))
        tiePath.closeSubpath()
        ctx.addPath(tiePath); ctx.fillPath()
        // Tie knot
        ctx.setFillColor(UIColor(red: 0.45, green: 0.08, blue: 0.08, alpha: 1).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.44, y: h*0.25, width: w*0.12, height: h*0.05))

        // Left arm holding papers
        ctx.setFillColor(suit)
        ctx.fill(CGRect(x: w*0.00, y: h*0.28, width: w*0.15, height: h*0.25))
        // Papers in hand
        ctx.setFillColor(paper)
        ctx.fill(CGRect(x: w*0.00, y: h*0.38, width: w*0.20, height: h*0.18))
        ctx.setFillColor(UIColor(red: 0.60, green: 0.58, blue: 0.54, alpha: 0.5).cgColor)
        for i in 0..<4 {
            ctx.fill(CGRect(x: w*0.02, y: h*(0.40 + Double(i)*0.038), width: w*0.16, height: h*0.015))
        }
        // Right arm raised (pointing at board)
        ctx.setFillColor(suit)
        ctx.fill(CGRect(x: w*0.82, y: h*0.20, width: w*0.15, height: h*0.22))
        ctx.setFillColor(skin)
        ctx.fillEllipse(in: CGRect(x: w*0.82, y: h*0.18, width: w*0.15, height: h*0.08))

        // Neck
        ctx.setFillColor(skin)
        ctx.fill(CGRect(x: w*0.40, y: h*0.16, width: w*0.20, height: h*0.13))

        // Head
        ctx.fillEllipse(in: CGRect(x: w*0.20, y: h*0.02, width: w*0.60, height: h*0.22))

        // Thinning brown hair on top
        ctx.setFillColor(hair)
        let hairPath = CGMutablePath()
        hairPath.move(to: CGPoint(x: w*0.20, y: h*0.11))
        hairPath.addCurve(to: CGPoint(x: w*0.80, y: h*0.11),
                          control1: CGPoint(x: w*0.24, y: h*(-0.01)),
                          control2: CGPoint(x: w*0.76, y: h*(-0.01)))
        hairPath.addLine(to: CGPoint(x: w*0.80, y: h*0.07))
        hairPath.addCurve(to: CGPoint(x: w*0.20, y: h*0.07),
                          control1: CGPoint(x: w*0.72, y: h*(-0.02)),
                          control2: CGPoint(x: w*0.28, y: h*(-0.02)))
        hairPath.closeSubpath()
        ctx.addPath(hairPath); ctx.fillPath()
        // Side patches only (balding on top)
        ctx.fill(CGRect(x: w*0.18, y: h*0.08, width: w*0.14, height: h*0.12))
        ctx.fill(CGRect(x: w*0.68, y: h*0.08, width: w*0.14, height: h*0.12))

        // Glasses frames
        ctx.setStrokeColor(UIColor(red: 0.22, green: 0.16, blue: 0.08, alpha: 1).cgColor)
        ctx.setLineWidth(2.0)
        ctx.stroke(CGRect(x: w*0.24, y: h*0.09, width: w*0.18, height: h*0.072).insetBy(dx: 0, dy: 0))
        ctx.stroke(CGRect(x: w*0.58, y: h*0.09, width: w*0.18, height: h*0.072).insetBy(dx: 0, dy: 0))
        // Bridge
        ctx.move(to: CGPoint(x: w*0.42, y: h*0.120)); ctx.addLine(to: CGPoint(x: w*0.58, y: h*0.120)); ctx.strokePath()

        // Eyes behind glasses
        ctx.setFillColor(UIColor(red: 0.25, green: 0.18, blue: 0.08, alpha: 1).cgColor)
        ctx.fillEllipse(in: CGRect(x: w*0.29, y: h*0.100, width: w*0.08, height: h*0.048))
        ctx.fillEllipse(in: CGRect(x: w*0.63, y: h*0.100, width: w*0.08, height: h*0.048))

        // Stern eyebrows
        ctx.setStrokeColor(hair)
        ctx.setLineWidth(2.0)
        ctx.move(to: CGPoint(x: w*0.23, y: h*0.088)); ctx.addLine(to: CGPoint(x: w*0.42, y: h*0.082)); ctx.strokePath()
        ctx.move(to: CGPoint(x: w*0.58, y: h*0.082)); ctx.addLine(to: CGPoint(x: w*0.77, y: h*0.088)); ctx.strokePath()

        // Mouth (thin, slightly displeased)
        ctx.setStrokeColor(UIColor(red: 0.50, green: 0.28, blue: 0.16, alpha: 1).cgColor)
        ctx.setLineWidth(1.5)
        ctx.move(to: CGPoint(x: w*0.36, y: h*0.185)); ctx.addLine(to: CGPoint(x: w*0.64, y: h*0.185)); ctx.strokePath()
    }

    // MARK: - Locker Bank

    private static func drawLockerBank(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let lockerW = w / 5
        let colors: [CGColor] = [
            UIColor(red: 0.72, green: 0.14, blue: 0.14, alpha: 1).cgColor,
            UIColor(red: 0.14, green: 0.30, blue: 0.68, alpha: 1).cgColor,
            UIColor(red: 0.18, green: 0.50, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 0.60, green: 0.55, blue: 0.14, alpha: 1).cgColor,
            UIColor(red: 0.50, green: 0.18, blue: 0.50, alpha: 1).cgColor
        ]
        for i in 0..<5 {
            let lx = CGFloat(i) * lockerW
            // Body
            ctx.setFillColor(colors[i % colors.count])
            ctx.fill(CGRect(x: lx + 1, y: 1, width: lockerW - 2, height: h - 2))
            // Highlight edge
            ctx.setFillColor(UIColor.white.withAlphaComponent(0.15).cgColor)
            ctx.fill(CGRect(x: lx + 1, y: 1, width: 3, height: h - 2))
            // Shadow edge
            ctx.setFillColor(UIColor.black.withAlphaComponent(0.20).cgColor)
            ctx.fill(CGRect(x: lx + lockerW - 4, y: 1, width: 3, height: h - 2))
            // Vent slats
            ctx.setFillColor(UIColor.black.withAlphaComponent(0.35).cgColor)
            for v in 0..<4 {
                ctx.fill(CGRect(x: lx + lockerW*0.18, y: h*(0.12 + Double(v)*0.06),
                                width: lockerW*0.64, height: h*0.02))
            }
            // Handle
            ctx.setFillColor(UIColor(red: 0.75, green: 0.72, blue: 0.68, alpha: 1).cgColor)
            ctx.fillEllipse(in: CGRect(x: lx + lockerW*0.70, y: h*0.42,
                                       width: lockerW*0.12, height: h*0.08))
            // Combination lock
            ctx.setFillColor(UIColor(red: 0.62, green: 0.60, blue: 0.56, alpha: 1).cgColor)
            ctx.fillEllipse(in: CGRect(x: lx + lockerW*0.36, y: h*0.44,
                                       width: lockerW*0.26, height: h*0.08))
        }
        // Divider lines
        ctx.setFillColor(UIColor(red: 0.20, green: 0.18, blue: 0.16, alpha: 1).cgColor)
        for i in 1..<5 {
            ctx.fill(CGRect(x: CGFloat(i) * lockerW - 1, y: 0, width: 2, height: h))
        }
    }

    // MARK: - School Floor

    private static func drawSchoolFloor(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height
        let tileSize: CGFloat = 40
        let light = UIColor(red: 0.90, green: 0.88, blue: 0.84, alpha: 1).cgColor
        let dark  = UIColor(red: 0.72, green: 0.70, blue: 0.66, alpha: 1).cgColor

        var row = 0
        var y: CGFloat = 0
        while y < h {
            var col = 0
            var x: CGFloat = 0
            while x < w {
                ctx.setFillColor((row + col) % 2 == 0 ? light : dark)
                ctx.fill(CGRect(x: x, y: y, width: tileSize, height: tileSize))
                // Grout lines
                ctx.setFillColor(UIColor(red: 0.55, green: 0.53, blue: 0.50, alpha: 0.5).cgColor)
                ctx.fill(CGRect(x: x, y: y, width: tileSize, height: 1.5))
                ctx.fill(CGRect(x: x, y: y, width: 1.5, height: tileSize))
                x += tileSize; col += 1
            }
            y += tileSize; row += 1
        }
    }

    // MARK: - Chalkboard

    private static func drawChalkboard(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height

        // Wooden frame
        ctx.setFillColor(UIColor(red: 0.55, green: 0.35, blue: 0.15, alpha: 1).cgColor)
        ctx.fill(r)

        // Green board surface
        ctx.setFillColor(UIColor(red: 0.12, green: 0.32, blue: 0.18, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.04, y: h*0.06, width: w*0.92, height: h*0.80))

        // Board texture (subtle lighter patches)
        ctx.setFillColor(UIColor(red: 0.16, green: 0.36, blue: 0.22, alpha: 0.5).cgColor)
        ctx.fill(CGRect(x: w*0.10, y: h*0.12, width: w*0.30, height: h*0.25))
        ctx.fill(CGRect(x: w*0.55, y: h*0.40, width: w*0.35, height: h*0.28))

        // Chalk tray
        ctx.setFillColor(UIColor(red: 0.42, green: 0.26, blue: 0.10, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.04, y: h*0.86, width: w*0.92, height: h*0.08))
        // Chalk pieces in tray
        let chalkColors: [CGColor] = [UIColor.white.cgColor,
                                       UIColor(red: 0.95, green: 0.85, blue: 0.50, alpha: 1).cgColor,
                                       UIColor(red: 0.80, green: 0.90, blue: 0.98, alpha: 1).cgColor]
        for (ci, cx) in [0.12, 0.22, 0.50].enumerated() {
            ctx.setFillColor(chalkColors[ci])
            ctx.fill(CGRect(x: w*cx, y: h*0.875, width: w*0.08, height: h*0.045))
        }

        // Written text — "HISTORY REPORT"
        ctx.setFillColor(UIColor.white.withAlphaComponent(0.88).cgColor)
        // Simulate underline title
        ctx.fill(CGRect(x: w*0.08, y: h*0.17, width: w*0.84, height: h*0.025))
        // Text lines (chalk scribble effect — horizontal bars of varying opacity)
        let lineY: [CGFloat] = [0.28, 0.38, 0.48, 0.58, 0.68]
        for ly in lineY {
            ctx.setFillColor(UIColor.white.withAlphaComponent(CGFloat.random(in: 0.55...0.80)).cgColor)
            ctx.fill(CGRect(x: w*0.08, y: h*ly, width: w*CGFloat.random(in: 0.50...0.80), height: h*0.018))
        }
        // "DUE FRIDAY" underline — red chalk
        ctx.setFillColor(UIColor(red: 0.95, green: 0.25, blue: 0.20, alpha: 0.90).cgColor)
        ctx.fill(CGRect(x: w*0.08, y: h*0.750, width: w*0.55, height: h*0.022))
    }

    // MARK: - School Exterior

    private static func drawSchoolExterior(in r: CGRect, ctx: CGContext) {
        let w = r.width, h = r.height

        // Sky
        ctx.setFillColor(UIColor(red: 0.65, green: 0.82, blue: 0.96, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: h * 0.55))

        // Grass strip
        ctx.setFillColor(UIColor(red: 0.32, green: 0.60, blue: 0.24, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: h*0.55, width: w, height: h * 0.10))

        // School building — brick red facade
        ctx.setFillColor(UIColor(red: 0.65, green: 0.28, blue: 0.22, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: h*0.10, width: w, height: h * 0.50))

        // Brick rows
        ctx.setStrokeColor(UIColor(red: 0.42, green: 0.18, blue: 0.14, alpha: 0.5).cgColor)
        ctx.setLineWidth(1.0)
        var by: CGFloat = h * 0.12
        while by < h * 0.58 {
            ctx.move(to: CGPoint(x: 0, y: by)); ctx.addLine(to: CGPoint(x: w, y: by)); ctx.strokePath()
            by += h * 0.04
        }
        // Vertical brick joints (offset per row)
        let brickW: CGFloat = w / 6
        for row in 0..<12 {
            let offset: CGFloat = row % 2 == 0 ? 0 : brickW / 2
            var bx = offset
            while bx < w {
                let rowY = h * 0.12 + CGFloat(row) * h * 0.04
                ctx.move(to: CGPoint(x: bx, y: rowY)); ctx.addLine(to: CGPoint(x: bx, y: rowY + h*0.04)); ctx.strokePath()
                bx += brickW
            }
        }

        // Windows (3)
        let winY: CGFloat = h * 0.18
        let winH: CGFloat = h * 0.20
        let winW: CGFloat = w * 0.18
        for i in 0..<3 {
            let wx = w * (0.12 + Double(i) * 0.30)
            // Frame
            ctx.setFillColor(UIColor(red: 0.80, green: 0.72, blue: 0.56, alpha: 1).cgColor)
            ctx.fill(CGRect(x: wx - 3, y: winY - 3, width: winW + 6, height: winH + 6))
            // Glass (light blue)
            ctx.setFillColor(UIColor(red: 0.72, green: 0.88, blue: 0.96, alpha: 0.75).cgColor)
            ctx.fill(CGRect(x: wx, y: winY, width: winW, height: winH))
            // Cross divider
            ctx.setFillColor(UIColor(red: 0.80, green: 0.72, blue: 0.56, alpha: 1).cgColor)
            ctx.fill(CGRect(x: wx + winW/2 - 1.5, y: winY, width: 3, height: winH))
            ctx.fill(CGRect(x: wx, y: winY + winH/2 - 1.5, width: winW, height: 3))
        }

        // Sign banner above entrance
        ctx.setFillColor(UIColor(red: 0.14, green: 0.18, blue: 0.48, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.25, y: h*0.06, width: w*0.50, height: h*0.07))
        ctx.setFillColor(UIColor.white.withAlphaComponent(0.90).cgColor)
        // "SAN DIMAS HIGH" as white stripes
        ctx.fill(CGRect(x: w*0.28, y: h*0.075, width: w*0.44, height: h*0.018))
        ctx.fill(CGRect(x: w*0.30, y: h*0.098, width: w*0.40, height: h*0.018))

        // Entrance doors (double doors)
        ctx.setFillColor(UIColor(red: 0.32, green: 0.28, blue: 0.22, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.38, y: h*0.38, width: w*0.24, height: h*0.27))
        ctx.setFillColor(UIColor(red: 0.72, green: 0.88, blue: 0.96, alpha: 0.55).cgColor)
        ctx.fill(CGRect(x: w*0.39, y: h*0.39, width: w*0.10, height: h*0.26))
        ctx.fill(CGRect(x: w*0.51, y: h*0.39, width: w*0.10, height: h*0.26))
        // Door handles
        ctx.setFillColor(UIColor(red: 0.75, green: 0.70, blue: 0.25, alpha: 1).cgColor)
        ctx.fill(CGRect(x: w*0.482, y: h*0.505, width: w*0.018, height: h*0.04))
        ctx.fill(CGRect(x: w*0.500, y: h*0.505, width: w*0.018, height: h*0.04))

        // Sidewalk
        ctx.setFillColor(UIColor(red: 0.76, green: 0.74, blue: 0.70, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: h*0.62, width: w, height: h * 0.38))
        // Sidewalk cracks
        ctx.setStrokeColor(UIColor(red: 0.58, green: 0.56, blue: 0.52, alpha: 0.5).cgColor)
        ctx.setLineWidth(1)
        ctx.move(to: CGPoint(x: w*0.3, y: h*0.65)); ctx.addLine(to: CGPoint(x: w*0.35, y: h*0.85)); ctx.strokePath()
        ctx.move(to: CGPoint(x: w*0.7, y: h*0.70)); ctx.addLine(to: CGPoint(x: w*0.66, y: h*0.90)); ctx.strokePath()
    }
}
