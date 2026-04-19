//  PlayerNode.swift
//  BillandTedsExcellentAdventure

import SpriteKit

class PlayerNode: SKSpriteNode {

    let characterType: CharacterType

    var isOnGround = false
    var jumpCount   = 0
    let maxJumps    = 2

    var isMovingLeft  = false
    var isMovingRight = false

    // MARK: - Init

    init(characterType: CharacterType) {
        self.characterType = characterType
        let size = CGSize(width: 40, height: 60)
        super.init(texture: nil, color: characterType.color, size: size)
        setupPhysics()
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(characterType:)")
    }

    // MARK: - Setup

    private func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
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

    private func setupLabel() {
        let label = SKLabelNode(text: characterType == .bill ? "B" : "T")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 28
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.isUserInteractionEnabled = false
        addChild(label)
    }

    // MARK: - Actions

    func jump() {
        guard jumpCount < maxJumps else { return }
        physicsBody?.velocity.dy = 0
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: characterType.jumpImpulse))
        jumpCount += 1
        isOnGround = false
    }

    func useAbility() {
        switch characterType {
        case .bill: airGuitarShred()
        case .ted:  bogusDistraction()
        }
    }

    private func airGuitarShred() {
        let wave = SKShapeNode(circleOfRadius: 80)
        wave.strokeColor = .systemYellow
        wave.lineWidth   = 3
        wave.fillColor   = UIColor.systemYellow.withAlphaComponent(0.15)
        addChild(wave)
        wave.run(.sequence([
            .group([.scale(to: 2, duration: 0.4), .fadeOut(withDuration: 0.4)]),
            .removeFromParent()
        ]))
    }

    private func bogusDistraction() {
        let swirl = SKShapeNode(circleOfRadius: 60)
        swirl.strokeColor = .systemGreen
        swirl.lineWidth   = 3
        swirl.fillColor   = UIColor.systemGreen.withAlphaComponent(0.15)
        addChild(swirl)
        swirl.run(.sequence([
            .group([.rotate(byAngle: .pi * 4, duration: 0.6), .fadeOut(withDuration: 0.6)]),
            .removeFromParent()
        ]))
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
    }
}
