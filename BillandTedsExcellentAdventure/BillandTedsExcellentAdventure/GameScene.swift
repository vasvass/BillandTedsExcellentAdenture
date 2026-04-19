//  GameScene.swift
//  BillandTedsExcellentAdventure

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Constants

    private let levelWidth: CGFloat = 3200
    private let groundTopY: CGFloat = 80   // world Y of the ground surface

    // MARK: - Properties

    private var player:     PlayerNode!
    private var cam:        SKCameraNode!
    private var hud:        SKNode!         // attached to cam
    private var controls:   SKNode!         // attached to cam

    private var leftButton:    SKShapeNode!
    private var rightButton:   SKShapeNode!
    private var jumpButton:    SKShapeNode!
    private var abilityButton: SKShapeNode!
    private var switchPrompt:  SKLabelNode!

    // Track active control touches so multi-finger works correctly
    private var leftTouchID:  UITouch?
    private var rightTouchID: UITouch?

    private var nearPhoneBooth     = false
    private var socratesCollected  = false
    private var currentCharacter:  CharacterType
    private var lastUpdateTime:    TimeInterval = 0

    // MARK: - Init

    init(size: CGSize, character: CharacterType) {
        self.currentCharacter = character
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        self.currentCharacter = .bill
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.53, green: 0.81, blue: 0.98, alpha: 1)

        physicsWorld.gravity          = CGVector(dx: 0, dy: -18)
        physicsWorld.contactDelegate  = self

        setupCamera()
        buildLevel()
        setupPlayer()
        cam.position = CGPoint(
            x: player.position.x.clamped(to: (size.width / 2)...(levelWidth - size.width / 2)),
            y: player.position.y.clamped(to: (size.height / 2)...max(size.height / 2, size.height - size.height / 2))
        )
        setupHUD()
        setupControls()
    }

    // MARK: - Camera

    private func setupCamera() {
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
    }

    // MARK: - Level

    private func buildLevel() {
        addSkyDecoration()
        addGround()
        addPlatforms()
        addPhoneBooth()
        addSocrates()
        addEnemies()
    }

    // Background decoration: sun + distant hill silhouettes
    private func addSkyDecoration() {
        let sun = SKShapeNode(circleOfRadius: 55)
        sun.fillColor = .systemYellow
        sun.strokeColor = .clear
        sun.position = CGPoint(x: levelWidth - 300, y: size.height - 100)
        sun.zPosition = -9
        addChild(sun)

        // Simple column silhouettes suggesting ancient ruins
        let columnXs: [CGFloat] = [300, 700, 1100, 1700, 2300, 2800]
        for x in columnXs {
            let col = SKSpriteNode(color: SKColor(white: 0.85, alpha: 0.35),
                                   size: CGSize(width: 18, height: 130))
            col.position = CGPoint(x: x, y: groundTopY + 65)
            col.zPosition = -8
            addChild(col)
        }
    }

    private func addGround() {
        // A single wide platform that forms the floor
        let groundH: CGFloat = 60
        let ground = SKSpriteNode(
            color: SKColor(red: 0.76, green: 0.70, blue: 0.50, alpha: 1),
            size:  CGSize(width: levelWidth + 400, height: groundH)
        )
        ground.position = CGPoint(x: levelWidth / 2, y: groundTopY - groundH / 2)
        applyStaticPhysics(to: ground, categoryBitMask: PhysicsCategory.ground,
                           collisionBitMask: PhysicsCategory.player | PhysicsCategory.enemy)
        ground.zPosition = 1
        addChild(ground)
    }

    private func addPlatforms() {
        let specs: [(x: CGFloat, y: CGFloat, w: CGFloat)] = [
            (320,  180, 160),
            (560,  270, 140),
            (820,  190, 150),
            (1080, 300, 180),
            (1320, 220, 140),
            (1570, 340, 160),
            (1800, 210, 130),
            (2060, 290, 170),
            (2320, 250, 145),
            (2580, 320, 155),
            (2820, 200, 140),
        ]
        for s in specs {
            let platform = SKSpriteNode(
                color: SKColor(red: 0.85, green: 0.80, blue: 0.65, alpha: 1),
                size:  CGSize(width: s.w, height: 18)
            )
            platform.position = CGPoint(x: s.x, y: s.y)
            applyStaticPhysics(to: platform, categoryBitMask: PhysicsCategory.ground,
                               collisionBitMask: PhysicsCategory.player | PhysicsCategory.enemy)
            platform.zPosition = 2
            addChild(platform)
        }
    }

    private func addPhoneBooth() {
        let boothSize = CGSize(width: 52, height: 96)
        let booth = SKShapeNode(rectOf: boothSize, cornerRadius: 6)
        booth.fillColor   = SKColor(red: 0.08, green: 0.48, blue: 0.08, alpha: 1)
        booth.strokeColor = .white
        booth.lineWidth   = 2
        booth.position    = CGPoint(x: levelWidth - 180, y: groundTopY + boothSize.height / 2)
        booth.name        = "phoneBooth"
        booth.zPosition   = 3

        let pb = SKPhysicsBody(rectangleOf: boothSize)
        pb.isDynamic           = false
        pb.categoryBitMask     = PhysicsCategory.phoneBooth
        pb.contactTestBitMask  = PhysicsCategory.player
        pb.collisionBitMask    = PhysicsCategory.none
        booth.physicsBody      = pb

        // Label
        let title = SKLabelNode(text: "PHONE")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 9
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 6)
        title.verticalAlignmentMode = .center
        booth.addChild(title)

        let title2 = SKLabelNode(text: "BOOTH")
        title2.fontName = "AvenirNext-Bold"
        title2.fontSize = 9
        title2.fontColor = .white
        title2.position = CGPoint(x: 0, y: -6)
        title2.verticalAlignmentMode = .center
        booth.addChild(title2)

        // Pulse glow
        booth.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.65, duration: 1.0),
            .fadeAlpha(to: 1.00, duration: 1.0)
        ])))
        addChild(booth)
    }

    private func addSocrates() {
        let size = CGSize(width: 38, height: 58)
        let node = SKShapeNode(rectOf: size, cornerRadius: 5)
        node.fillColor   = .systemPurple
        node.strokeColor = .white
        node.lineWidth   = 1.5
        node.position    = CGPoint(x: levelWidth - 340, y: groundTopY + size.height / 2)
        node.name        = "socrates"
        node.zPosition   = 3

        let pb = SKPhysicsBody(rectangleOf: size)
        pb.isDynamic          = false
        pb.categoryBitMask    = PhysicsCategory.collectible
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.none
        node.physicsBody      = pb

        let letter = SKLabelNode(text: "S")
        letter.fontName = "AvenirNext-Bold"
        letter.fontSize = 26
        letter.fontColor = .white
        letter.verticalAlignmentMode = .center
        node.addChild(letter)

        let nameLabel = SKLabelNode(text: "Socrates")
        nameLabel.fontName = "AvenirNext-Medium"
        nameLabel.fontSize = 11
        nameLabel.fontColor = .white
        nameLabel.position  = CGPoint(x: 0, y: 38)
        node.addChild(nameLabel)

        // Idle float
        node.run(.repeatForever(.sequence([
            .moveBy(x: 0, y: 7, duration: 0.9),
            .moveBy(x: 0, y: -7, duration: 0.9)
        ])))
        addChild(node)
    }

    private func addEnemies() {
        let xs: [CGFloat] = [420, 760, 1250, 1680, 2200, 2700]
        for x in xs { spawnEnemy(at: CGPoint(x: x, y: groundTopY + 25)) }
    }

    private func spawnEnemy(at position: CGPoint) {
        let size = CGSize(width: 38, height: 50)
        let enemy = SKShapeNode(rectOf: size, cornerRadius: 4)
        enemy.fillColor   = .systemRed
        enemy.strokeColor = .clear
        enemy.position    = position
        enemy.name        = "enemy"
        enemy.zPosition   = 2

        let pb = SKPhysicsBody(rectangleOf: size)
        pb.isDynamic          = true
        pb.allowsRotation     = false
        pb.categoryBitMask    = PhysicsCategory.enemy
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.ground
        pb.friction           = 0.8
        pb.linearDamping      = 0.5
        enemy.physicsBody     = pb

        let lbl = SKLabelNode(text: "G")
        lbl.fontName = "AvenirNext-Bold"
        lbl.fontSize = 20
        lbl.fontColor = .white
        lbl.verticalAlignmentMode = .center
        enemy.addChild(lbl)

        addChild(enemy)

        let patrol: CGFloat = 130
        enemy.run(.repeatForever(.sequence([
            .moveBy(x:  patrol, y: 0, duration: 1.6),
            .moveBy(x: -patrol, y: 0, duration: 1.6)
        ])))
    }

    // MARK: - Player

    private func setupPlayer() {
        player = PlayerNode(characterType: currentCharacter)
        player.position = CGPoint(x: 120, y: groundTopY + 60)
        player.zPosition = 10
        addChild(player)
    }

    // MARK: - HUD

    private func setupHUD() {
        hud = SKNode()
        hud.zPosition = 100
        cam.addChild(hud)

        let eraLabel = makeHUDLabel("Ancient Greece  —  410 BC", fontSize: 13, color: .white)
        eraLabel.position = CGPoint(x: 0, y: size.height / 2 - 30)
        hud.addChild(eraLabel)

        refreshCharacterHUD()
    }

    private func refreshCharacterHUD() {
        hud.childNode(withName: "charHUD")?.removeFromParent()

        let container = SKNode()
        container.name = "charHUD"
        container.position = CGPoint(x: -size.width / 2 + 68, y: size.height / 2 - 72)

        let bg = SKShapeNode(rectOf: CGSize(width: 110, height: 52), cornerRadius: 10)
        bg.fillColor   = UIColor.black.withAlphaComponent(0.5)
        bg.strokeColor = currentCharacter.color
        bg.lineWidth   = 1.5
        container.addChild(bg)

        let nameLbl = makeHUDLabel(currentCharacter == .bill ? "BILL" : "TED", fontSize: 18, color: currentCharacter.color)
        nameLbl.position = CGPoint(x: 0, y: 7)
        container.addChild(nameLbl)

        let abilityLbl = makeHUDLabel(currentCharacter.ability, fontSize: 8, color: .lightGray)
        abilityLbl.position = CGPoint(x: 0, y: -11)
        container.addChild(abilityLbl)

        hud.addChild(container)
    }

    private func makeHUDLabel(_ text: String, fontSize: CGFloat, color: UIColor) -> SKLabelNode {
        let lbl = SKLabelNode(text: text)
        lbl.fontName = "AvenirNext-Medium"
        lbl.fontSize = fontSize
        lbl.fontColor = color
        lbl.horizontalAlignmentMode = .center
        lbl.verticalAlignmentMode   = .center
        return lbl
    }

    // MARK: - Controls

    private func setupControls() {
        controls = SKNode()
        controls.zPosition = 100
        cam.addChild(controls)

        let btnY  = -size.height / 2 + 72
        let leftX = -size.width  / 2 + 60

        leftButton    = controlButton("◀", at: CGPoint(x: leftX,       y: btnY), name: "leftButton")
        rightButton   = controlButton("▶", at: CGPoint(x: leftX + 80,  y: btnY), name: "rightButton")
        jumpButton    = controlButton("▲", at: CGPoint(x: size.width / 2 - 68,  y: btnY),     name: "jumpButton")
        abilityButton = controlButton("★", at: CGPoint(x: size.width / 2 - 148, y: btnY),     name: "abilityButton")

        controls.addChild(leftButton)
        controls.addChild(rightButton)
        controls.addChild(jumpButton)
        controls.addChild(abilityButton)

        // Phone-booth switch prompt (hidden until player is near)
        switchPrompt = SKLabelNode(text: "▲ SWITCH CHARACTER")
        switchPrompt.fontName = "AvenirNext-Bold"
        switchPrompt.fontSize = 14
        switchPrompt.fontColor = .systemGreen
        switchPrompt.position  = CGPoint(x: 0, y: -size.height / 2 + 136)
        switchPrompt.name      = "switchPrompt"
        switchPrompt.isHidden  = true
        controls.addChild(switchPrompt)

        // Flash the switch prompt when visible
        switchPrompt.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.3, duration: 0.5),
            .fadeAlpha(to: 1.0, duration: 0.5)
        ])))
    }

    private func controlButton(_ symbol: String, at position: CGPoint, name: String) -> SKShapeNode {
        let btn = SKShapeNode(circleOfRadius: 30)
        btn.fillColor   = UIColor.white.withAlphaComponent(0.18)
        btn.strokeColor = UIColor.white.withAlphaComponent(0.45)
        btn.lineWidth   = 1.5
        btn.position    = position
        btn.name        = name

        let lbl = SKLabelNode(text: symbol)
        lbl.fontName = "AvenirNext-Bold"
        lbl.fontSize = 22
        lbl.fontColor = .white
        lbl.verticalAlignmentMode   = .center
        lbl.isUserInteractionEnabled = false
        btn.addChild(lbl)

        return btn
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { processTouch(touch, phase: .began) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { processTouch(touch, phase: .ended) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetMovement()
    }

    private func processTouch(_ touch: UITouch, phase: UITouch.Phase) {
        let locInCam = touch.location(in: cam)
        let hitNodes = cam.nodes(at: locInCam)

        for node in hitNodes {
            let name = node.name ?? node.parent?.name ?? ""
            switch (name, phase) {
            case ("leftButton", .began):
                leftTouchID = touch
                player.isMovingLeft = true
                leftButton.fillColor = UIColor.white.withAlphaComponent(0.38)

            case ("leftButton", .ended):
                if touch === leftTouchID {
                    leftTouchID = nil
                    player.isMovingLeft = false
                    leftButton.fillColor = UIColor.white.withAlphaComponent(0.18)
                }

            case ("rightButton", .began):
                rightTouchID = touch
                player.isMovingRight = true
                rightButton.fillColor = UIColor.white.withAlphaComponent(0.38)

            case ("rightButton", .ended):
                if touch === rightTouchID {
                    rightTouchID = nil
                    player.isMovingRight = false
                    rightButton.fillColor = UIColor.white.withAlphaComponent(0.18)
                }

            case ("jumpButton", .began):
                flashButton(jumpButton)

                // Repurpose jump button near booth as switch action
                if nearPhoneBooth {
                    switchCharacter()
                } else {
                    player.jump()
                }

            case ("abilityButton", .began):
                player.useAbility()
                flashButton(abilityButton)

            default:
                break
            }
        }
    }

    private func flashButton(_ btn: SKShapeNode) {
        btn.fillColor = UIColor.white.withAlphaComponent(0.42)
        btn.run(.sequence([
            .wait(forDuration: 0.12),
            .run { btn.fillColor = UIColor.white.withAlphaComponent(0.18) }
        ]))
    }

    private var supportingGroundBodies = Set<ObjectIdentifier>()

    private func resetMovement() {
        leftTouchID  = nil
        rightTouchID = nil
        player.isMovingLeft  = false
        player.isMovingRight = false
    }

    // MARK: - Physics contacts

    private func playerGroundBodies(for contact: SKPhysicsContact) -> (player: SKPhysicsBody, ground: SKPhysicsBody)? {
        if contact.bodyA.categoryBitMask == PhysicsCategory.player &&
           contact.bodyB.categoryBitMask == PhysicsCategory.ground {
            return (contact.bodyA, contact.bodyB)
        }

        if contact.bodyA.categoryBitMask == PhysicsCategory.ground &&
           contact.bodyB.categoryBitMask == PhysicsCategory.player {
            return (contact.bodyB, contact.bodyA)
        }

        return nil
    }

    private func isSupportingGroundContact(_ contact: SKPhysicsContact) -> Bool {
        guard let groundBodies = playerGroundBodies(for: contact) else { return false }

        if groundBodies.player == contact.bodyA {
            return contact.contactNormal.dy < -0.5
        } else {
            return contact.contactNormal.dy > 0.5
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let masks = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)

        if let groundBodies = playerGroundBodies(for: contact),
           isSupportingGroundContact(contact) {
            supportingGroundBodies.insert(ObjectIdentifier(groundBodies.ground))
            player.isOnGround = true
            player.jumpCount  = 0
        }

        if masks == (PhysicsCategory.player, PhysicsCategory.phoneBooth) ||
           masks == (PhysicsCategory.phoneBooth, PhysicsCategory.player) {
            nearPhoneBooth = true
            switchPrompt.isHidden = false
        }

        if masks == (PhysicsCategory.player, PhysicsCategory.collectible) ||
           masks == (PhysicsCategory.collectible, PhysicsCategory.player) {
            let collectible = contact.bodyA.categoryBitMask == PhysicsCategory.collectible
                ? contact.bodyA.node : contact.bodyB.node
            collectSocrates(collectible)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let masks = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)

        if let groundBodies = playerGroundBodies(for: contact) {
            supportingGroundBodies.remove(ObjectIdentifier(groundBodies.ground))
            player.isOnGround = !supportingGroundBodies.isEmpty
        }

        if masks == (PhysicsCategory.player, PhysicsCategory.phoneBooth) ||
           masks == (PhysicsCategory.phoneBooth, PhysicsCategory.player) {
            nearPhoneBooth = false
            switchPrompt.isHidden = true
        }
    }

    // MARK: - Game events

    private func collectSocrates(_ node: SKNode?) {
        guard let node = node, !socratesCollected else { return }
        socratesCollected = true
        node.physicsBody = nil
        node.run(.sequence([
            .group([.scale(to: 2, duration: 0.3), .fadeOut(withDuration: 0.3)]),
            .removeFromParent()
        ]))
        showBanner("Socrates collected!  Be excellent! 🤘")
    }

    private func switchCharacter() {
        currentCharacter = currentCharacter == .bill ? .ted : .bill

        let pos = player.position
        let isLeft  = player.isMovingLeft
        let isRight = player.isMovingRight
        player.removeFromParent()

        player = PlayerNode(characterType: currentCharacter)
        player.position      = pos
        player.zPosition     = 10
        player.isMovingLeft  = isLeft
        player.isMovingRight = isRight
        addChild(player)

        refreshCharacterHUD()
        showBanner("Switched to \(currentCharacter == .bill ? "Bill" : "Ted")!")
    }

    private func showBanner(_ text: String) {
        let lbl = SKLabelNode(text: text)
        lbl.fontName = "AvenirNext-Bold"
        lbl.fontSize = 17
        lbl.fontColor = .systemYellow
        lbl.position  = CGPoint(x: 0, y: size.height / 2 - 80)
        lbl.zPosition = 200
        cam.addChild(lbl)

        lbl.run(.sequence([
            .wait(forDuration: 2.0),
            .fadeOut(withDuration: 0.5),
            .removeFromParent()
        ]))
    }

    // MARK: - Update

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        player.update(deltaTime: dt)
        updateCamera()
        clampPlayer()
    }

    private func updateCamera() {
        let halfW = size.width  / 2
        let halfH = size.height / 2

        let targetX = player.position.x.clamped(to: halfW...(levelWidth - halfW))
        let targetY = max(halfH, player.position.y + 80)

        let t: CGFloat = 0.12
        cam.position.x += (targetX - cam.position.x) * t
        cam.position.y += (targetY - cam.position.y) * t
    }

    private func clampPlayer() {
        player.position.x = player.position.x.clamped(to: 30...(levelWidth - 30))

        // Fell below the world — respawn
        if player.position.y < -300 {
            player.position = CGPoint(x: 120, y: groundTopY + 60)
            player.physicsBody?.velocity = .zero
        }
    }

    // MARK: - Physics helpers

    private func applyStaticPhysics(to node: SKSpriteNode,
                                    categoryBitMask: UInt32,
                                    collisionBitMask: UInt32) {
        let pb = SKPhysicsBody(rectangleOf: node.size)
        pb.isDynamic         = false
        pb.friction          = 0.8
        pb.categoryBitMask   = categoryBitMask
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask  = collisionBitMask
        node.physicsBody     = pb
    }
}

// MARK: - Comparable clamping helper

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
