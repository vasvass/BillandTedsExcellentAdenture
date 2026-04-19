//  GameScene.swift
//  BillandTedsExcellentAdventure

import SpriteKit
import GameplayKit

// MARK: - Enemy tracking

private struct EnemyData {
    let node: SKSpriteNode
    let patrolOrigin: CGFloat
    let patrolRange:  CGFloat
    var chasing: Bool = false
    var stunned: Bool = false
    var alive:   Bool = true
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Constants

    private let levelWidth: CGFloat  = 3200
    private let groundTopY: CGFloat  = 80
    private let chaseRange: CGFloat  = 220
    private let loseRange:  CGFloat  = 380
    private let chaseSpeed: CGFloat  = 140
    private let patrolSpeed: CGFloat = 80

    // MARK: - Properties

    private var player:    PlayerNode!
    private var cam:       SKCameraNode!
    private var hud:       SKNode!
    private var controls:  SKNode!
    private var victoryOverlay: SKNode?

    private var leftButton:    SKShapeNode!
    private var rightButton:   SKShapeNode!
    private var jumpButton:    SKShapeNode!
    private var abilityButton: SKShapeNode!
    private var switchPrompt:  SKLabelNode!

    private var leftTouchID:  UITouch?
    private var rightTouchID: UITouch?

    private var nearPhoneBooth    = false
    private var socratesCollected = false
    private var levelComplete     = false
    private var currentCharacter: CharacterType
    private var lastUpdateTime:   TimeInterval = 0
    private var playerHP          = 3
    private var isHit             = false

    private var enemies: [EnemyData] = []
    private var supportingGroundBodies = Set<ObjectIdentifier>()

    // Parallax layers
    private var farBgNode:  SKNode!
    private var midBgNode:  SKNode!
    private var cloudNode:  SKNode!

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
        backgroundColor = SKColor(red: 0.30, green: 0.58, blue: 0.90, alpha: 1)
        physicsWorld.gravity         = CGVector(dx: 0, dy: -18)
        physicsWorld.contactDelegate = self

        setupCamera()
        buildBackground()
        buildLevel()
        setupPlayer()
        cam.position = CGPoint(
            x: player.position.x.clamped(to: (size.width / 2)...(levelWidth - size.width / 2)),
            y: player.position.y.clamped(to: (size.height / 2)...max(size.height / 2, size.height))
        )
        setupHUD()
        setupControls()
    }

    // Reposition all camera-anchored UI when screen size changes (rotation)
    override func didChangeSize(_ oldSize: CGSize) {
        guard oldSize != size, hud != nil else { return }
        repositionHUD()
        repositionControls()
    }

    // MARK: - Camera

    private func setupCamera() {
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
    }

    // MARK: - Background

    private func buildBackground() {
        addSkyPanel()
        addMountainLayer()
        addClouds()
        addDistantRuins()
    }

    private func addSkyPanel() {
        let skyH = max(size.height * 2.5, 900)
        let skyTex = SpriteFactory.skyTexture(size: CGSize(width: 512, height: skyH))
        let sky = SKSpriteNode(texture: skyTex)
        sky.size = CGSize(width: levelWidth + size.width, height: skyH)
        sky.position = CGPoint(x: levelWidth / 2, y: groundTopY + skyH / 2 - 20)
        sky.zPosition = -20
        addChild(sky)

        let sunGlow = SKShapeNode(circleOfRadius: 80)
        sunGlow.fillColor   = UIColor(red: 1.0, green: 0.90, blue: 0.50, alpha: 0.25)
        sunGlow.strokeColor = .clear
        sunGlow.position    = CGPoint(x: levelWidth - 280, y: groundTopY + size.height * 0.72)
        sunGlow.zPosition   = -15
        addChild(sunGlow)

        let sun = SKShapeNode(circleOfRadius: 52)
        sun.fillColor   = UIColor(red: 1.0, green: 0.88, blue: 0.35, alpha: 1)
        sun.strokeColor = UIColor(red: 1.0, green: 0.96, blue: 0.70, alpha: 0.6)
        sun.lineWidth   = 6
        sun.position    = sunGlow.position
        sun.zPosition   = -14
        addChild(sun)

        for i in 0..<8 {
            let angle = CGFloat(i) * .pi / 4
            let ray = SKShapeNode()
            let p = CGMutablePath()
            p.move(to: CGPoint(x: cos(angle) * 58, y: sin(angle) * 58))
            p.addLine(to: CGPoint(x: cos(angle) * 85, y: sin(angle) * 85))
            ray.path = p
            ray.strokeColor = UIColor(red: 1.0, green: 0.92, blue: 0.50, alpha: 0.55)
            ray.lineWidth   = 4
            ray.lineCap     = .round
            ray.position    = sun.position
            ray.zPosition   = -14
            addChild(ray)
        }
    }

    private func addMountainLayer() {
        farBgNode = SKNode()
        farBgNode.zPosition = -18
        addChild(farBgNode)

        let mtnH: CGFloat = 260
        let mtnW: CGFloat = 800
        var x: CGFloat = 0
        var flip = false
        while x < levelWidth + mtnW {
            let tex  = SpriteFactory.mountainTexture(size: CGSize(width: mtnW, height: mtnH))
            let node = SKSpriteNode(texture: tex)
            node.size     = CGSize(width: mtnW, height: mtnH)
            node.xScale   = flip ? -1 : 1
            node.position = CGPoint(x: x + mtnW / 2, y: groundTopY + mtnH / 2 - 10)
            farBgNode.addChild(node)
            x += mtnW * 0.78
            flip.toggle()
        }
    }

    private func addClouds() {
        cloudNode = SKNode()
        cloudNode.zPosition = -12
        addChild(cloudNode)

        let specs: [(CGFloat, CGFloat, CGFloat)] = [
            (220, 0.60, 1.0), (580, 0.72, 0.85), (950, 0.55, 1.1),
            (1300, 0.68, 0.9), (1700, 0.62, 1.0), (2100, 0.70, 0.8),
            (2500, 0.58, 1.15), (2900, 0.65, 0.95)
        ]
        for (xPos, yFrac, scale) in specs {
            let cloud = makeCloud()
            cloud.position = CGPoint(x: xPos, y: groundTopY + size.height * yFrac)
            cloud.setScale(scale)
            cloudNode.addChild(cloud)
            let drift = CGFloat.random(in: 18...30)
            let dur   = TimeInterval(CGFloat.random(in: 14...22))
            cloud.run(.repeatForever(.sequence([
                .moveBy(x: drift,  y: 0, duration: dur),
                .moveBy(x: -drift, y: 0, duration: dur)
            ])))
        }
    }

    private func makeCloud() -> SKNode {
        let root = SKNode()
        for (bx, by, br) in [(0.0, 0.0, 34.0), (-30.0, -8.0, 24.0),
                              (32.0, -10.0, 26.0), (-10.0, 14.0, 20.0), (18.0, 12.0, 18.0)] {
            let blob = SKShapeNode(circleOfRadius: br)
            blob.fillColor   = UIColor.white.withAlphaComponent(0.82)
            blob.strokeColor = .clear
            blob.position    = CGPoint(x: bx, y: by)
            root.addChild(blob)
        }
        return root
    }

    private func addDistantRuins() {
        midBgNode = SKNode()
        midBgNode.zPosition = -10
        addChild(midBgNode)

        let xs: [CGFloat] = [180, 440, 750, 1050, 1380, 1720, 2080, 2420, 2760, 3050]
        for x in xs {
            let colW: CGFloat = 24
            let colH = CGFloat(Int.random(in: 90...140))
            let tex  = SpriteFactory.columnTexture(width: colW * 2, height: colH * 2)
            let col  = SKSpriteNode(texture: tex)
            col.size     = CGSize(width: colW, height: colH)
            col.alpha    = 0.38
            col.position = CGPoint(x: x, y: groundTopY + colH / 2)
            midBgNode.addChild(col)
        }
    }

    // MARK: - Level

    private func buildLevel() {
        addGround()
        addPlatforms()
        addForegroundColumns()
        addPhoneBooth()
        addSocrates()
        addEnemies()
    }

    private func addGround() {
        let groundH: CGFloat = 60
        let tex = SpriteFactory.groundTexture(size: CGSize(width: 512, height: groundH * 2))
        let ground = SKSpriteNode(texture: tex)
        ground.size     = CGSize(width: levelWidth + 400, height: groundH)
        ground.position = CGPoint(x: levelWidth / 2, y: groundTopY - groundH / 2)
        ground.zPosition = 1
        applyStaticPhysics(to: ground, category: PhysicsCategory.ground,
                           collision: PhysicsCategory.player | PhysicsCategory.enemy)
        addChild(ground)
    }

    private func addPlatforms() {
        let specs: [(CGFloat, CGFloat, CGFloat)] = [
            (320, 180, 160), (560, 270, 140), (820, 190, 150),
            (1080, 300, 180), (1320, 220, 140), (1570, 340, 160),
            (1800, 210, 130), (2060, 290, 170), (2320, 250, 145),
            (2580, 320, 155), (2820, 200, 140)
        ]
        for (x, y, w) in specs {
            let h: CGFloat = 18
            let tex = SpriteFactory.platformTexture(size: CGSize(width: w * 2, height: h * 2))
            let plat = SKSpriteNode(texture: tex)
            plat.size     = CGSize(width: w, height: h)
            plat.position = CGPoint(x: x, y: y)
            plat.zPosition = 2
            applyStaticPhysics(to: plat, category: PhysicsCategory.ground,
                               collision: PhysicsCategory.player | PhysicsCategory.enemy)
            addChild(plat)
        }
    }

    private func addForegroundColumns() {
        for (x, h, w) in [(500.0, 110.0, 30.0), (900.0, 130.0, 36.0), (1400.0, 120.0, 32.0),
                           (1900.0, 140.0, 38.0), (2400.0, 115.0, 30.0), (2900.0, 130.0, 34.0)] {
            let tex = SpriteFactory.columnTexture(width: w * 2, height: h * 2)
            let col = SKSpriteNode(texture: tex)
            col.size     = CGSize(width: w, height: h)
            col.position = CGPoint(x: x, y: groundTopY + h / 2)
            col.zPosition = -2
            addChild(col)
        }
    }

    private func addPhoneBooth() {
        let boothW: CGFloat = 52, boothH: CGFloat = 96
        let booth = SKSpriteNode(texture: SpriteFactory.phoneBoothTexture())
        booth.size     = CGSize(width: boothW, height: boothH)
        booth.position = CGPoint(x: levelWidth - 180, y: groundTopY + boothH / 2)
        booth.name     = "phoneBooth"
        booth.zPosition = 3

        let pb = SKPhysicsBody(rectangleOf: CGSize(width: boothW, height: boothH))
        pb.isDynamic          = false
        pb.categoryBitMask    = PhysicsCategory.phoneBooth
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.none
        booth.physicsBody     = pb

        booth.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.75, duration: 1.2),
            .fadeAlpha(to: 1.00, duration: 1.2)
        ])))

        let glow = SKShapeNode(ellipseOf: CGSize(width: 80, height: 16))
        glow.fillColor   = UIColor(red: 0.10, green: 0.50, blue: 1.00, alpha: 0.35)
        glow.strokeColor = .clear
        glow.position    = CGPoint(x: levelWidth - 180, y: groundTopY + 4)
        glow.zPosition   = 2
        glow.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.10, duration: 1.2),
            .fadeAlpha(to: 0.40, duration: 1.2)
        ])))
        addChild(glow)
        addChild(booth)
    }

    private func addSocrates() {
        let gameSize = CGSize(width: 38, height: 58)
        let node = SKSpriteNode(texture: SpriteFactory.socratesTexture())
        node.size     = gameSize
        node.position = CGPoint(x: levelWidth - 340, y: groundTopY + gameSize.height / 2)
        node.name     = "socrates"
        node.zPosition = 3

        let pb = SKPhysicsBody(rectangleOf: gameSize)
        pb.isDynamic          = false
        pb.categoryBitMask    = PhysicsCategory.collectible
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.none
        node.physicsBody      = pb

        let nameLabel = SKLabelNode(text: "Socrates")
        nameLabel.fontName  = "AvenirNext-Medium"
        nameLabel.fontSize  = 11
        nameLabel.fontColor = UIColor(red: 1.0, green: 0.95, blue: 0.70, alpha: 1)
        nameLabel.position  = CGPoint(x: 0, y: gameSize.height / 2 + 8)
        nameLabel.verticalAlignmentMode = .bottom
        node.addChild(nameLabel)

        let aura = SKShapeNode(circleOfRadius: 30)
        aura.fillColor   = UIColor(red: 1.0, green: 0.88, blue: 0.30, alpha: 0.18)
        aura.strokeColor = UIColor(red: 1.0, green: 0.88, blue: 0.30, alpha: 0.40)
        aura.lineWidth   = 1.5
        aura.zPosition   = -1
        node.addChild(aura)

        node.run(.repeatForever(.sequence([
            .moveBy(x: 0, y: 8,  duration: 1.0),
            .moveBy(x: 0, y: -8, duration: 1.0)
        ])))
        addChild(node)
    }

    private func addEnemies() {
        let xs: [CGFloat] = [420, 760, 1250, 1680, 2200, 2700]
        for x in xs { spawnEnemy(at: CGPoint(x: x, y: groundTopY + 25)) }
    }

    private func spawnEnemy(at position: CGPoint) {
        let gameSize = CGSize(width: 38, height: 50)
        let node = SKSpriteNode(texture: SpriteFactory.enemyTexture())
        node.size     = gameSize
        node.position = position
        node.name     = "enemy"
        node.zPosition = 2

        let pb = SKPhysicsBody(rectangleOf: CGSize(width: 32, height: 48))
        pb.isDynamic          = true
        pb.allowsRotation     = false
        pb.categoryBitMask    = PhysicsCategory.enemy
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.ground
        pb.friction           = 0.8
        pb.linearDamping      = 0.8
        pb.restitution        = 0
        node.physicsBody      = pb

        addChild(node)
        enemies.append(EnemyData(node: node, patrolOrigin: position.x, patrolRange: 130))
    }

    // MARK: - Player

    private func setupPlayer() {
        player = PlayerNode(characterType: currentCharacter)
        player.position  = CGPoint(x: 120, y: groundTopY + 60)
        player.zPosition = 10
        addChild(player)
    }

    // MARK: - HUD

    private func setupHUD() {
        hud = SKNode()
        hud.zPosition = 100
        cam.addChild(hud)
        repositionHUD()
    }

    private func repositionHUD() {
        hud.removeAllChildren()

        // Era label
        let eraBg = SKShapeNode(rectOf: CGSize(width: 240, height: 24), cornerRadius: 6)
        eraBg.fillColor   = UIColor.black.withAlphaComponent(0.45)
        eraBg.strokeColor = .clear
        eraBg.position    = CGPoint(x: 0, y: size.height / 2 - 30)
        hud.addChild(eraBg)

        let eraLabel = hudLabel("Ancient Greece  —  410 BC", size: 13, color: .white)
        eraLabel.position = eraBg.position
        hud.addChild(eraLabel)

        // HP hearts
        buildHPDisplay()

        // Character card
        buildCharacterCard()
    }

    private func buildHPDisplay() {
        hud.childNode(withName: "hpRow")?.removeFromParent()
        let row = SKNode()
        row.name = "hpRow"
        row.position = CGPoint(x: size.width / 2 - 60, y: size.height / 2 - 30)
        for i in 0..<3 {
            let heart = SKLabelNode(text: i < playerHP ? "♥" : "♡")
            heart.fontName  = "AvenirNext-Bold"
            heart.fontSize  = 18
            heart.fontColor = i < playerHP ? UIColor(red: 1, green: 0.25, blue: 0.25, alpha: 1) : .darkGray
            heart.position  = CGPoint(x: CGFloat(i) * 22, y: 0)
            heart.verticalAlignmentMode = .center
            row.addChild(heart)
        }
        hud.addChild(row)
    }

    private func buildCharacterCard() {
        hud.childNode(withName: "charHUD")?.removeFromParent()
        let container = SKNode()
        container.name     = "charHUD"
        container.position = CGPoint(x: -size.width / 2 + 68, y: size.height / 2 - 72)

        let bg = SKShapeNode(rectOf: CGSize(width: 110, height: 52), cornerRadius: 10)
        bg.fillColor   = UIColor.black.withAlphaComponent(0.55)
        bg.strokeColor = currentCharacter.color
        bg.lineWidth   = 1.5
        container.addChild(bg)

        let portrait = SKSpriteNode(texture: SpriteFactory.playerTexture(for: currentCharacter))
        portrait.size     = CGSize(width: 22, height: 33)
        portrait.position = CGPoint(x: -36, y: 0)
        container.addChild(portrait)

        let nameLbl = hudLabel(currentCharacter == .bill ? "BILL" : "TED",
                               size: 18, color: currentCharacter.color)
        nameLbl.position = CGPoint(x: 10, y: 7)
        container.addChild(nameLbl)

        let abilityLbl = hudLabel(currentCharacter.ability, size: 8, color: .lightGray)
        abilityLbl.position = CGPoint(x: 10, y: -11)
        container.addChild(abilityLbl)

        hud.addChild(container)
    }

    private func hudLabel(_ text: String, size fontSize: CGFloat, color: UIColor) -> SKLabelNode {
        let lbl = SKLabelNode(text: text)
        lbl.fontName  = "AvenirNext-Medium"
        lbl.fontSize  = fontSize
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
        repositionControls()
    }

    private func repositionControls() {
        controls.removeAllChildren()

        let btnY  = -size.height / 2 + 72
        let leftX = -size.width  / 2 + 60

        leftButton    = controlButton("◀", at: CGPoint(x: leftX,      y: btnY), name: "leftButton")
        rightButton   = controlButton("▶", at: CGPoint(x: leftX + 80, y: btnY), name: "rightButton")
        jumpButton    = controlButton("▲", at: CGPoint(x: size.width / 2 - 68,  y: btnY), name: "jumpButton")
        abilityButton = controlButton("★", at: CGPoint(x: size.width / 2 - 148, y: btnY), name: "abilityButton")

        controls.addChild(leftButton)
        controls.addChild(rightButton)
        controls.addChild(jumpButton)
        controls.addChild(abilityButton)

        switchPrompt = SKLabelNode(text: socratesCollected ? "▲ ENTER BOOTH" : "▲ SWITCH CHARACTER")
        switchPrompt.fontName = "AvenirNext-Bold"
        switchPrompt.fontSize = 14
        switchPrompt.fontColor = UIColor(red: 0.30, green: 0.90, blue: 1.00, alpha: 1)
        switchPrompt.position  = CGPoint(x: 0, y: -size.height / 2 + 136)
        switchPrompt.isHidden  = !nearPhoneBooth
        controls.addChild(switchPrompt)

        switchPrompt.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.25, duration: 0.5),
            .fadeAlpha(to: 1.00, duration: 0.5)
        ])))
    }

    private func controlButton(_ symbol: String, at pos: CGPoint, name: String) -> SKShapeNode {
        let btn = SKShapeNode(circleOfRadius: 30)
        btn.fillColor   = UIColor.white.withAlphaComponent(0.18)
        btn.strokeColor = UIColor.white.withAlphaComponent(0.45)
        btn.lineWidth   = 1.5
        btn.position    = pos
        btn.name        = name

        let lbl = SKLabelNode(text: symbol)
        lbl.fontName  = "AvenirNext-Bold"
        lbl.fontSize  = 22
        lbl.fontColor = .white
        lbl.verticalAlignmentMode    = .center
        lbl.isUserInteractionEnabled = false
        btn.addChild(lbl)
        return btn
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { handleTouch(t, phase: .began) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { handleTouch(t, phase: .ended) }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { resetMovement() }

    private func handleTouch(_ touch: UITouch, phase: UITouch.Phase) {
        guard !levelComplete else {
            // Any tap on victory overlay dismisses to menu
            if phase == .began { returnToMenu() }
            return
        }

        let loc = touch.location(in: cam)
        for node in cam.nodes(at: loc) {
            let name = node.name ?? node.parent?.name ?? ""
            switch (name, phase) {
            case ("leftButton", .began):
                leftTouchID = touch; player.isMovingLeft = true
                leftButton.fillColor = UIColor.white.withAlphaComponent(0.38)
            case ("leftButton", .ended):
                if touch === leftTouchID {
                    leftTouchID = nil; player.isMovingLeft = false
                    leftButton.fillColor = UIColor.white.withAlphaComponent(0.18)
                }
            case ("rightButton", .began):
                rightTouchID = touch; player.isMovingRight = true
                rightButton.fillColor = UIColor.white.withAlphaComponent(0.38)
            case ("rightButton", .ended):
                if touch === rightTouchID {
                    rightTouchID = nil; player.isMovingRight = false
                    rightButton.fillColor = UIColor.white.withAlphaComponent(0.18)
                }
            case ("jumpButton", .began):
                flashButton(jumpButton)
                if nearPhoneBooth {
                    socratesCollected ? triggerLevelComplete() : switchCharacter()
                } else {
                    player.jump()
                }
            case ("abilityButton", .began):
                player.useAbility(); flashButton(abilityButton)
                stunNearbyEnemies()
            default: break
            }
        }
    }

    private func flashButton(_ btn: SKShapeNode) {
        btn.fillColor = UIColor.white.withAlphaComponent(0.42)
        btn.run(.sequence([.wait(forDuration: 0.12),
                           .run { btn.fillColor = UIColor.white.withAlphaComponent(0.18) }]))
    }

    private func resetMovement() {
        leftTouchID = nil; rightTouchID = nil
        player.isMovingLeft = false; player.isMovingRight = false
    }

    // MARK: - Enemy AI update

    private func updateEnemies() {
        let px = player.position.x
        let py = player.position.y

        for i in enemies.indices {
            guard enemies[i].alive, !enemies[i].stunned else { continue }
            let node = enemies[i].node
            guard let body = node.physicsBody else { continue }

            let dist = abs(node.position.x - px)

            if dist < chaseRange {
                // Chase player
                enemies[i].chasing = true
                let dir: CGFloat = px < node.position.x ? -1 : 1
                body.velocity = CGVector(dx: dir * chaseSpeed,
                                         dy: body.velocity.dy)
                node.xScale = dir

                // Leaping: if player is significantly above and close, jump
                if py > node.position.y + 60 && dist < 80 && body.velocity.dy == 0 {
                    body.applyImpulse(CGVector(dx: 0, dy: 280))
                }

            } else if enemies[i].chasing && dist > loseRange {
                enemies[i].chasing = false
            }

            if !enemies[i].chasing {
                // Patrol: bounce within range of origin
                let origin = enemies[i].patrolOrigin
                let range  = enemies[i].patrolRange
                if node.position.x < origin - range {
                    body.velocity = CGVector(dx: patrolSpeed, dy: body.velocity.dy)
                    node.xScale = 1
                } else if node.position.x > origin + range {
                    body.velocity = CGVector(dx: -patrolSpeed, dy: body.velocity.dy)
                    node.xScale = -1
                } else if body.velocity.dx == 0 {
                    // Nudge if stalled
                    body.velocity = CGVector(dx: patrolSpeed, dy: body.velocity.dy)
                    node.xScale = 1
                }
            }
        }
    }

    // MARK: - Physics contacts

    func didBegin(_ contact: SKPhysicsContact) {
        let masks = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)

        // Player ↔ Ground
        if let groundBodies = groundContactPair(contact), isSupportingContact(contact) {
            supportingGroundBodies.insert(ObjectIdentifier(groundBodies.ground))
            player.isOnGround = true
            player.jumpCount  = 0
        }

        // Player ↔ Phone booth
        if masks == (PhysicsCategory.player, PhysicsCategory.phoneBooth) ||
           masks == (PhysicsCategory.phoneBooth, PhysicsCategory.player) {
            nearPhoneBooth = true
            switchPrompt.isHidden  = false
            switchPrompt.text      = socratesCollected ? "▲ ENTER BOOTH" : "▲ SWITCH CHARACTER"
        }

        // Player ↔ Collectible
        if masks == (PhysicsCategory.player, PhysicsCategory.collectible) ||
           masks == (PhysicsCategory.collectible, PhysicsCategory.player) {
            let node = contact.bodyA.categoryBitMask == PhysicsCategory.collectible
                ? contact.bodyA.node : contact.bodyB.node
            collectSocrates(node)
        }

        // Player ↔ Enemy
        if masks == (PhysicsCategory.player, PhysicsCategory.enemy) ||
           masks == (PhysicsCategory.enemy, PhysicsCategory.player) {
            let enemyNode = contact.bodyA.categoryBitMask == PhysicsCategory.enemy
                ? contact.bodyA.node as? SKSpriteNode
                : contact.bodyB.node as? SKSpriteNode

            // Stomp: player lands on top of enemy
            let playerAbove = player.position.y > (enemyNode?.position.y ?? 0) + 18
            if playerAbove {
                stompEnemy(enemyNode)
                // Bounce player up
                player.physicsBody?.velocity.dy = 0
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 400))
                player.jumpCount = 1
            } else {
                hitPlayer()
            }
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let masks = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)

        if let groundBodies = groundContactPair(contact) {
            supportingGroundBodies.remove(ObjectIdentifier(groundBodies.ground))
            player.isOnGround = !supportingGroundBodies.isEmpty
        }

        if masks == (PhysicsCategory.player, PhysicsCategory.phoneBooth) ||
           masks == (PhysicsCategory.phoneBooth, PhysicsCategory.player) {
            nearPhoneBooth    = false
            switchPrompt.isHidden = true
        }
    }

    private func groundContactPair(_ contact: SKPhysicsContact)
        -> (player: SKPhysicsBody, ground: SKPhysicsBody)? {
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

    private func isSupportingContact(_ contact: SKPhysicsContact) -> Bool {
        guard let pair = groundContactPair(contact) else { return false }
        return pair.player == contact.bodyA
            ? contact.contactNormal.dy < -0.5
            : contact.contactNormal.dy >  0.5
    }

    // MARK: - Combat

    private func stompEnemy(_ node: SKSpriteNode?) {
        guard let node = node else { return }
        guard let idx = enemies.firstIndex(where: { $0.node === node }), enemies[idx].alive else { return }
        enemies[idx].alive = false
        node.physicsBody = nil

        // Stars burst
        for _ in 0..<6 {
            let star = SKLabelNode(text: "★")
            star.fontName  = "AvenirNext-Bold"
            star.fontSize  = 14
            star.fontColor = UIColor(red: 1.0, green: 0.85, blue: 0.10, alpha: 1)
            star.position  = node.position
            star.zPosition = 20
            addChild(star)
            let angle = CGFloat.random(in: 0...(.pi * 2))
            star.run(.sequence([
                .group([
                    .moveBy(x: cos(angle)*50, y: sin(angle)*50, duration: 0.4),
                    .fadeOut(withDuration: 0.4)
                ]),
                .removeFromParent()
            ]))
        }
        node.run(.sequence([
            .scaleX(to: 1.4, y: 0.2, duration: 0.12),
            .fadeOut(withDuration: 0.15),
            .removeFromParent()
        ]))
    }

    private func hitPlayer() {
        guard !isHit, !levelComplete else { return }
        isHit = true
        playerHP = max(0, playerHP - 1)
        buildHPDisplay()

        // Knockback
        let dir: CGFloat = player.xScale >= 0 ? -1 : 1
        player.physicsBody?.velocity = CGVector(dx: dir * 200, dy: 250)

        // Flash red
        player.run(.sequence([
            .repeat(.sequence([
                .colorize(with: .red, colorBlendFactor: 0.9, duration: 0.08),
                .colorize(with: .clear, colorBlendFactor: 0.0, duration: 0.08)
            ]), count: 4),
            .run { [weak self] in self?.isHit = false }
        ]))

        if playerHP <= 0 { respawnPlayer() }
    }

    private func respawnPlayer() {
        playerHP = 3
        buildHPDisplay()
        showBanner("Bogus! Try again!")
        player.run(.sequence([
            .wait(forDuration: 0.5),
            .run { [weak self] in
                guard let self else { return }
                self.player.position = CGPoint(x: 120, y: self.groundTopY + 60)
                self.player.physicsBody?.velocity = .zero
            }
        ]))
        // Revive all enemies
        for i in enemies.indices {
            enemies[i].alive   = true
            enemies[i].chasing = false
            enemies[i].stunned = false
            enemies[i].node.alpha = 1
            if enemies[i].node.parent == nil {
                addChild(enemies[i].node)
            }
            let pb = SKPhysicsBody(rectangleOf: CGSize(width: 32, height: 48))
            pb.isDynamic          = true
            pb.allowsRotation     = false
            pb.categoryBitMask    = PhysicsCategory.enemy
            pb.contactTestBitMask = PhysicsCategory.player
            pb.collisionBitMask   = PhysicsCategory.ground
            pb.friction           = 0.8
            pb.linearDamping      = 0.8
            pb.restitution        = 0
            enemies[i].node.physicsBody = pb
            enemies[i].node.position = CGPoint(x: enemies[i].patrolOrigin, y: groundTopY + 25)
        }
    }

    private func stunNearbyEnemies() {
        let stunRadius: CGFloat = 160
        for i in enemies.indices {
            guard enemies[i].alive, !enemies[i].stunned else { continue }
            if abs(enemies[i].node.position.x - player.position.x) < stunRadius {
                enemies[i].stunned = true
                enemies[i].node.physicsBody?.velocity = .zero
                enemies[i].node.run(.sequence([
                    .colorize(with: .yellow, colorBlendFactor: 0.8, duration: 0.1),
                    .wait(forDuration: 2.0),
                    .colorize(with: .clear, colorBlendFactor: 0.0, duration: 0.2),
                    .run { [weak self] in
                        if let idx = self?.enemies.firstIndex(where: { $0.node === self?.enemies[i].node }) {
                            self?.enemies[idx].stunned = false
                        }
                    }
                ]))
            }
        }
    }

    // MARK: - Collectibles

    private func collectSocrates(_ node: SKNode?) {
        guard let node = node, !socratesCollected else { return }
        socratesCollected = true
        node.physicsBody  = nil

        for _ in 0..<8 {
            let spark = SKShapeNode(circleOfRadius: 4)
            spark.fillColor   = UIColor(red: 1.0, green: 0.88, blue: 0.25, alpha: 1)
            spark.strokeColor = .clear
            spark.position    = node.position
            spark.zPosition   = 20
            addChild(spark)
            let angle = CGFloat.random(in: 0...(.pi * 2))
            let dist  = CGFloat.random(in: 40...90)
            spark.run(.sequence([
                .group([
                    .moveBy(x: cos(angle) * dist, y: sin(angle) * dist, duration: 0.4),
                    .fadeOut(withDuration: 0.4)
                ]),
                .removeFromParent()
            ]))
        }
        node.run(.sequence([
            .group([.scale(to: 2, duration: 0.3), .fadeOut(withDuration: 0.3)]),
            .removeFromParent()
        ]))
        showBanner("Socrates collected! Now reach the Phone Booth! 🤘")

        // Update prompt if already near booth
        if nearPhoneBooth { switchPrompt.text = "▲ ENTER BOOTH" }
    }

    // MARK: - Character switch

    private func switchCharacter() {
        currentCharacter = currentCharacter == .bill ? .ted : .bill
        let pos = player.position
        let movLeft = player.isMovingLeft; let movRight = player.isMovingRight
        player.removeFromParent()
        player = PlayerNode(characterType: currentCharacter)
        player.position = pos; player.zPosition = 10
        player.isMovingLeft = movLeft; player.isMovingRight = movRight
        addChild(player)
        buildCharacterCard()
        showBanner("Switched to \(currentCharacter == .bill ? "Bill" : "Ted")!")
    }

    // MARK: - Level complete

    private func triggerLevelComplete() {
        guard !levelComplete else { return }
        levelComplete = true
        resetMovement()

        // Freeze player
        player.physicsBody?.isDynamic = false
        player.run(.repeatForever(.sequence([
            .moveBy(x: 0, y: 6,  duration: 0.4),
            .moveBy(x: 0, y: -6, duration: 0.4)
        ])))

        // Celebration confetti
        for _ in 0..<20 {
            let colors: [UIColor] = [.systemYellow, .systemPink, .systemGreen, .systemOrange, .white]
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 4...8))
            dot.fillColor   = colors.randomElement()!
            dot.strokeColor = .clear
            dot.position    = CGPoint(
                x: player.position.x + CGFloat.random(in: -60...60),
                y: player.position.y + CGFloat.random(in: 0...40)
            )
            dot.zPosition = 15
            addChild(dot)
            let angle  = CGFloat.random(in: 0...(.pi * 2))
            let dist   = CGFloat.random(in: 60...160)
            let dur    = TimeInterval(CGFloat.random(in: 0.6...1.2))
            dot.run(.sequence([
                .group([
                    .moveBy(x: cos(angle) * dist, y: sin(angle) * dist + 60, duration: dur),
                    .rotate(byAngle: .pi * 2, duration: dur),
                    .fadeOut(withDuration: dur)
                ]),
                .removeFromParent()
            ]))
        }

        // Victory overlay (camera-space)
        let overlay = SKNode()
        overlay.zPosition = 300

        let dimBg = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        dimBg.fillColor   = UIColor.black.withAlphaComponent(0.55)
        dimBg.strokeColor = .clear
        overlay.addChild(dimBg)

        let panel = SKShapeNode(rectOf: CGSize(width: min(size.width - 60, 340), height: 240),
                                cornerRadius: 20)
        panel.fillColor   = UIColor(red: 0.05, green: 0.05, blue: 0.12, alpha: 0.96)
        panel.strokeColor = UIColor(red: 1.0, green: 0.82, blue: 0.10, alpha: 1)
        panel.lineWidth   = 3
        panel.position    = .zero
        overlay.addChild(panel)

        let title = SKLabelNode(text: "🎸 MOST EXCELLENT! 🎸")
        title.fontName  = "AvenirNext-Heavy"
        title.fontSize  = 22
        title.fontColor = UIColor(red: 1.0, green: 0.85, blue: 0.10, alpha: 1)
        title.position  = CGPoint(x: 0, y: 70)
        title.verticalAlignmentMode = .center
        overlay.addChild(title)

        let sub = SKLabelNode(text: "Ancient Greece — Complete!")
        sub.fontName  = "AvenirNext-Medium"
        sub.fontSize  = 15
        sub.fontColor = .white
        sub.position  = CGPoint(x: 0, y: 38)
        sub.verticalAlignmentMode = .center
        overlay.addChild(sub)

        let charLine = SKLabelNode(text: "Played as: \(currentCharacter == .bill ? "Bill" : "Ted")")
        charLine.fontName  = "AvenirNext-Medium"
        charLine.fontSize  = 13
        charLine.fontColor = currentCharacter.color
        charLine.position  = CGPoint(x: 0, y: 10)
        charLine.verticalAlignmentMode = .center
        overlay.addChild(charLine)

        let historical = SKLabelNode(text: "Historical figures collected: 1")
        historical.fontName  = "AvenirNext-Medium"
        historical.fontSize  = 13
        historical.fontColor = UIColor(red: 0.70, green: 0.95, blue: 0.70, alpha: 1)
        historical.position  = CGPoint(x: 0, y: -16)
        historical.verticalAlignmentMode = .center
        overlay.addChild(historical)

        let defeatedCount = enemies.filter { !$0.alive }.count
        let defeated = SKLabelNode(text: "Guards defeated: \(defeatedCount)")
        defeated.fontName  = "AvenirNext-Medium"
        defeated.fontSize  = 13
        defeated.fontColor = UIColor(red: 0.95, green: 0.70, blue: 0.70, alpha: 1)
        defeated.position  = CGPoint(x: 0, y: -40)
        defeated.verticalAlignmentMode = .center
        overlay.addChild(defeated)

        let tapHint = SKLabelNode(text: "Tap anywhere to return")
        tapHint.fontName  = "AvenirNext-Medium"
        tapHint.fontSize  = 13
        tapHint.fontColor = UIColor.lightGray
        tapHint.position  = CGPoint(x: 0, y: -85)
        tapHint.verticalAlignmentMode = .center
        tapHint.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.3, duration: 0.6),
            .fadeAlpha(to: 1.0, duration: 0.6)
        ])))
        overlay.addChild(tapHint)

        cam.addChild(overlay)
        victoryOverlay = overlay

        // Animate panel in
        panel.setScale(0.1)
        panel.run(.sequence([.wait(forDuration: 0.2), .scale(to: 1.0, duration: 0.35)]))
    }

    private func returnToMenu() {
        let scene = MenuScene(size: size)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: .fade(withDuration: 0.8))
    }

    // MARK: - Banner

    private func showBanner(_ text: String) {
        let bg = SKShapeNode(rectOf: CGSize(width: min(size.width - 40, 340), height: 32), cornerRadius: 8)
        bg.fillColor   = UIColor.black.withAlphaComponent(0.55)
        bg.strokeColor = .clear
        bg.position    = CGPoint(x: 0, y: size.height / 2 - 80)
        bg.zPosition   = 200
        cam.addChild(bg)

        let lbl = SKLabelNode(text: text)
        lbl.fontName  = "AvenirNext-Bold"
        lbl.fontSize  = 14
        lbl.fontColor = UIColor(red: 1.0, green: 0.88, blue: 0.25, alpha: 1)
        lbl.verticalAlignmentMode = .center
        bg.addChild(lbl)

        bg.run(.sequence([
            .wait(forDuration: 2.5),
            .fadeOut(withDuration: 0.5),
            .removeFromParent()
        ]))
    }

    // MARK: - Update

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        lastUpdateTime = currentTime

        guard !levelComplete else { return }

        player.update(deltaTime: 0)
        updateEnemies()
        updateCamera()
        updateParallax()
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

    private func updateParallax() {
        let camX = cam.position.x
        farBgNode.position.x = (camX - levelWidth / 2) * -0.20
        midBgNode.position.x = (camX - levelWidth / 2) * -0.50
        cloudNode.position.x = (camX - levelWidth / 2) * -0.30
    }

    private func clampPlayer() {
        player.position.x = player.position.x.clamped(to: 30...(levelWidth - 30))
        if player.position.y < -300 {
            player.position = CGPoint(x: 120, y: groundTopY + 60)
            player.physicsBody?.velocity = .zero
            hitPlayer()
        }
    }

    // MARK: - Physics helpers

    private func applyStaticPhysics(to node: SKSpriteNode, category: UInt32, collision: UInt32) {
        let pb = SKPhysicsBody(rectangleOf: node.size)
        pb.isDynamic          = false
        pb.friction           = 0.8
        pb.categoryBitMask    = category
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = collision
        node.physicsBody      = pb
    }
}

// MARK: - Comparable clamping

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
