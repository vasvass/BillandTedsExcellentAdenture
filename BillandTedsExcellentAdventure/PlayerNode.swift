//  PlayerNode.swift
//  BillandTedsExcellentAdventure

import SpriteKit

class PlayerNode: SKSpriteNode {

    let characterType: CharacterType

    var isOnGround = false
    private var wasOnGround = false
    var jumpCount   = 0
    let maxJumps    = 2

    var isMovingLeft  = false
    var isMovingRight = false

    // MARK: - Init

    init(characterType: CharacterType) {
        self.characterType = characterType
        let texture = SpriteFactory.playerTexture(for: characterType)
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 60))
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(characterType:)")
    }

    // MARK: - Setup

    private func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 34, height: 58))
        physicsBody?.categoryBitMask    = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.ground
                                        | PhysicsCategory.enemy
                                        | PhysicsCategory.collectible
                                        | PhysicsCategory.phoneBooth
        physicsBody?.collisionBitMask   = PhysicsCategory.ground
        physicsBody?.allowsRotation     = false
        physicsBody?.restitution        = 0
        physicsBody?.friction           = 0
        physicsBody?.linearDamping      = 0
        physicsBody?.mass               = 1
    }

    // MARK: - Actions

    func jump() {
        guard jumpCount < maxJumps, let body = physicsBody else { return }
        var velocity = body.velocity
        velocity.dy = 0
        body.velocity = velocity
        body.applyImpulse(CGVector(dx: 0, dy: characterType.jumpImpulse))
        jumpCount += 1
        isOnGround = false

        // Jump squash/stretch
        removeAction(forKey: "jumpAnim")
        let anim = SKAction.sequence([
            .scaleX(to: 0.80, y: 1.25, duration: 0.08),
            .scaleX(to: 1.10, y: 0.90, duration: 0.10),
            .scaleX(to: 1.00, y: 1.00, duration: 0.08)
        ])
        run(anim, withKey: "jumpAnim")
    }

    func useAbility() {
        switch characterType {
        case .bill: airGuitarShred()
        case .ted:  bogusDistraction()
        }
    }

    private func airGuitarShred() {
        // Sound-wave rings
        for i in 0..<3 {
            let ring = SKShapeNode(circleOfRadius: 50)
            ring.strokeColor = UIColor(red: 1.0, green: 0.85, blue: 0.10, alpha: 0.9)
            ring.lineWidth   = 3
            ring.fillColor   = .clear
            ring.zPosition   = 5
            addChild(ring)
            let delay = SKAction.wait(forDuration: TimeInterval(i) * 0.12)
            ring.run(.sequence([
                delay,
                .group([.scale(to: 3.5, duration: 0.5), .fadeOut(withDuration: 0.5)]),
                .removeFromParent()
            ]))
        }
        // Shake
        run(.sequence([
            .moveBy(x: -4, y: 0, duration: 0.05),
            .moveBy(x: 8,  y: 0, duration: 0.05),
            .moveBy(x: -4, y: 0, duration: 0.05)
        ]))
    }

    private func bogusDistraction() {
        // Green spiral rings
        for i in 0..<3 {
            let swirl = SKShapeNode(circleOfRadius: 40)
            swirl.strokeColor = UIColor(red: 0.10, green: 0.90, blue: 0.30, alpha: 0.9)
            swirl.lineWidth   = 3
            swirl.fillColor   = .clear
            swirl.zPosition   = 5
            addChild(swirl)
            let delay = SKAction.wait(forDuration: TimeInterval(i) * 0.10)
            swirl.run(.sequence([
                delay,
                .group([
                    .rotate(byAngle: .pi * 3, duration: 0.55),
                    .scale(to: 3.0, duration: 0.55),
                    .fadeOut(withDuration: 0.55)
                ]),
                .removeFromParent()
            ]))
        }
    }

    // MARK: - Update

    func update(deltaTime: TimeInterval) {
        guard let body = physicsBody else { return }

        if isMovingLeft {
            body.velocity.dx = -characterType.moveSpeed
            xScale = -1
        } else if isMovingRight {
            body.velocity.dx = characterType.moveSpeed
            xScale = 1
        } else {
            body.velocity.dx = 0
        }

        // Landing squash (only on air -> ground transition)
        if isOnGround && !wasOnGround && jumpCount == 0, action(forKey: "landAnim") == nil {
            let sign: CGFloat = xScale < 0 ? -1 : 1
            let squash = SKAction.sequence([
                .scaleX(to: 1.15 * sign, y: 0.85, duration: 0.06),
                .scaleX(to: 1.00 * sign, y: 1.00, duration: 0.06)
            ])
            run(squash, withKey: "landAnim")
        }

        wasOnGround = isOnGround
    }
}
