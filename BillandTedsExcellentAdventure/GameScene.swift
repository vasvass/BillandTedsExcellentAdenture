//  GameScene.swift
//  BillandTedsExcellentAdventure

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Constants

    private let levelWidth: CGFloat = 3200
    private let groundTopY: CGFloat = 80

    // MARK: - Properties

    private var player:     PlayerNode!
    private var cam:        SKCameraNode!
    private var hud:        SKNode!
    private var controls:   SKNode!

    private var leftButton:    SKShapeNode!
    private var rightButton:   SKShapeNode!
    private var jumpButton:    SKShapeNode!
    private var abilityButton: SKShapeNode!
    private var switchPrompt:  SKLabelNode!

    private var leftTouchID:  UITouch?
    private var rightTouchID: UITouch?

    private var nearPhoneBooth     = false
    private var socratesCollected  = false
    private var currentCharacter:  CharacterType
    private var lastUpdateTime:    TimeInterval = 0

    // Parallax layers (world-space, scrolled manually)
    private var farBgNode:  SKNode!   // mountains — 20% camera speed
    private var midBgNode:  SKNode!   // distant columns — 50% camera speed
    private var cloudNode:  SKNode!   // clouds — 30% camera speed

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

    // MARK: - Background

    private func buildBackground() {
        addSkyPanel()
        addMountainLayer()
        addClouds()
        addDistantRuins()
    }

    private func addSkyPanel() {
        // Full-level sky gradient strip at ground level
        let skyH = max(size.height * 2.5, 900)
        let skyTex = SpriteFactory.skyTexture(size: CGSize(width: 512, height: skyH))
        let sky = SKSpriteNode(texture: skyTex)
        sky.size = CGSize(width: levelWidth + size.width, height: skyH)
        sky.position = CGPoint(x: levelWidth / 2, y: groundTopY + skyH / 2 - 20)
        sky.zPosition = -20
        addChild(sky)

        // Sun — warm yellow, soft glow
        let sunGlow = SKShapeNode(circleOfRadius: 80)
        sunGlow.fillColor  = UIColor(red: 1.0, green: 0.90, blue: 0.50, alpha: 0.25)
        sunGlow.strokeColor = .clear
        sunGlow.position   = CGPoint(x: levelWidth - 280, y: groundTopY + size.height * 0.72)
        sunGlow.zPosition  = -15
        addChild(sunGlow)

        let sun = SKShapeNode(circleOfRadius: 52)
        sun.fillColor  = UIColor(red: 1.0, green: 0.88, blue: 0.35, alpha: 1)
        sun.strokeColor = UIColor(red: 1.0, green: 0.96, blue: 0.70, alpha: 0.6)
        sun.lineWidth  = 6
        sun.position   = CGPoint(x: levelWidth - 280, y: groundTopY + size.height * 0.72)
        sun.zPosition  = -14
        addChild(sun)

        // Sun rays
        for i in 0..<8 {
            let angle = CGFloat(i) * .pi / 4
            let ray = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: cos(angle) * 58, y: sin(angle) * 58))
            path.addLine(to: CGPoint(x: cos(angle) * 85, y: sin(angle) * 85))
            ray.path = path
            ray.strokeColor = UIColor(red: 1.0, green: 0.92, blue: 0.50, alpha: 0.55)
            ray.lineWidth = 4
            ray.lineCap = .round
            ray.position = sun.position
            ray.zPosition = -14
            addChild(ray)
        }
    }

    private func addMountainLayer() {
        farBgNode = SKNode()
        farBgNode.zPosition = -18
        addChild(farBgNode)

        let mtnH: CGFloat = 260
        let mtnW: CGFloat = 800
        // Tile mountains across full level
        var x: CGFloat = 0
        var flip = false
        while x < levelWidth + mtnW {
            let tex = SpriteFactory.mountainTexture(size: CGSize(width: mtnW, height: mtnH))
            let node = SKSpriteNode(texture: tex)
            node.size = CGSize(width: mtnW, height: mtnH)
            node.xScale = flip ? -1 : 1
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

        let cloudPositions: [(CGFloat, CGFloat, CGFloat)] = [
            (220,  0.60, 1.0), (580,  0.72, 0.85), (950,  0.55, 1.1),
            (1300, 0.68, 0.9), (1700, 0.62, 1.0),  (2100, 0.70, 0.8),
            (2500, 0.58, 1.15),(2900, 0.65, 0.95)
        ]
        for (xPos, yFrac, scale) in cloudPositions {
            let cloud = makeCloud()
            cloud.position = CGPoint(x: xPos, y: groundTopY + size.height * yFrac)
            cloud.setScale(scale)
            cloudNode.addChild(cloud)

            // Slow drift
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
        let blobs: [(CGFloat, CGFloat, CGFloat)] = [
            (0, 0, 34), (-30, -8, 24), (32, -10, 26), (-10, 14, 20), (18, 12, 18)
        ]
        for (bx, by, br) in blobs {
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

        // Partial background ruin columns (faded, small)
        let bgColXs: [CGFloat] = [180, 440, 750, 1050, 1380, 1720, 2080, 2420, 2760, 3050]
        for x in bgColXs {
            let colW: CGFloat = 24
            let colH: CGFloat = CGFloat.random(in: 90...140)
            let tex = SpriteFactory.columnTexture(width: colW * 2, height: colH * 2)
            let col = SKSpriteNode(texture: tex)
            col.size = CGSize(width: colW, height: colH)
            col.alpha = 0.38
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
        let texSize = CGSize(width: 512, height: groundH * 2)
        let tex = SpriteFactory.groundTexture(size: texSize)
        tex.filteringMode = .nearest

        let ground = SKSpriteNode(texture: tex)
        ground.size = CGSize(width: levelWidth + 400, height: groundH)
        ground.position = CGPoint(x: levelWidth / 2, y: groundTopY - groundH / 2)
        ground.zPosition = 1

        // Tile horizontally
        ground.texture?.filteringMode = .nearest
        if let t = ground.texture {
            t.usesMipmaps = false
        }

        applyStaticPhysics(to: ground, categoryBitMask: PhysicsCategory.ground,
                           collisionBitMask: PhysicsCategory.player | PhysicsCategory.enemy)
        addChild(ground)
    }

    private func addPlatforms() {
        let specs: [(x: CGFloat, y: CGFloat, w: CGFloat)] = [
            (320,  180, 160), (560,  270, 140), (820,  190, 150),
            (1080, 300, 180), (1320, 220, 140), (1570, 340, 160),
            (1800, 210, 130), (2060, 290, 170), (2320, 250, 145),
            (2580, 320, 155), (2820, 200, 140),
        ]
        for s in specs {
            let platH: CGFloat = 18
            let tex = SpriteFactory.platformTexture(size: CGSize(width: s.w * 2, height: platH * 2))
            let platform = SKSpriteNode(texture: tex)
            platform.size = CGSize(width: s.w, height: platH)
            platform.position = CGPoint(x: s.x, y: s.y)
            platform.zPosition = 2
            applyStaticPhysics(to: platform, categoryBitMask: PhysicsCategory.ground,
                               collisionBitMask: PhysicsCategory.player | PhysicsCategory.enemy)
            addChild(platform)
        }
    }

    private func addForegroundColumns() {
        // Full-height Doric columns in the foreground
        let colSpecs: [(CGFloat, CGFloat, CGFloat)] = [
            (500,  110, 30), (900,  130, 36), (1400, 120, 32),
            (1900, 140, 38), (2400, 115, 30), (2900, 130, 34)
        ]
        for (x, h, w) in colSpecs {
            let tex = SpriteFactory.columnTexture(width: w * 2, height: h * 2)
            let col = SKSpriteNode(texture: tex)
            col.size = CGSize(width: w, height: h)
            col.position = CGPoint(x: x, y: groundTopY + h / 2)
            col.zPosition = -2
            addChild(col)
        }
    }

    private func addPhoneBooth() {
        let boothW: CGFloat = 52
        let boothH: CGFloat = 96
        let boothSize = CGSize(width: boothW, height: boothH)

        let tex = SpriteFactory.phoneBoothTexture()
        let booth = SKSpriteNode(texture: tex)
        booth.size = boothSize
        booth.position = CGPoint(x: levelWidth - 180, y: groundTopY + boothH / 2)
        booth.name     = "phoneBooth"
        booth.zPosition = 3

        let pb = SKPhysicsBody(rectangleOf: boothSize)
        pb.isDynamic          = false
        pb.categoryBitMask    = PhysicsCategory.phoneBooth
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.none
        booth.physicsBody     = pb

        // Electrical glow pulse
        booth.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.75, duration: 1.2),
            .fadeAlpha(to: 1.00, duration: 1.2)
        ])))

        // Glow ring underneath
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
        let tex = SpriteFactory.socratesTexture()
        let node = SKSpriteNode(texture: tex)
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

        // Name label above
        let nameLabel = SKLabelNode(text: "Socrates")
        nameLabel.fontName = "AvenirNext-Medium"
        nameLabel.fontSize = 11
        nameLabel.fontColor = UIColor(red: 1.0, green: 0.95, blue: 0.70, alpha: 1)
        nameLabel.position  = CGPoint(x: 0, y: gameSize.height / 2 + 8)
        nameLabel.verticalAlignmentMode = .bottom
        node.addChild(nameLabel)

        // Golden glow aura
        let aura = SKShapeNode(circleOfRadius: 30)
        aura.fillColor   = UIColor(red: 1.0, green: 0.88, blue: 0.30, alpha: 0.18)
        aura.strokeColor = UIColor(red: 1.0, green: 0.88, blue: 0.30, alpha: 0.40)
        aura.lineWidth   = 1.5
        aura.zPosition   = -1
        node.addChild(aura)

        // Float animation
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
        let tex = SpriteFactory.enemyTexture()
        let enemy = SKSpriteNode(texture: tex)
        enemy.size     = gameSize
        enemy.position = position
        enemy.name     = "enemy"
        enemy.zPosition = 2

        let pb = SKPhysicsBody(rectangleOf: CGSize(width: 32, height: 48))
        pb.isDynamic          = true
        pb.allowsRotation     = false
        pb.categoryBitMask    = PhysicsCategory.enemy
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.ground
        pb.friction           = 0.8
        pb.linearDamping      = 0.5
        enemy.physicsBody     = pb

        addChild(enemy)

        let patrol: CGFloat = 130
        let dur: TimeInterval = 1.6
        let speed = patrol / CGFloat(dur)
        enemy.run(.repeatForever(.sequence([
            .run { [weak enemy] in
                enemy?.xScale = 1
                enemy?.physicsBody?.velocity = CGVector(dx: speed,  dy: enemy?.physicsBody?.velocity.dy ?? 0)
            },
            .wait(forDuration: dur),
            .run { [weak enemy] in
                enemy?.xScale = -1
                enemy?.physicsBody?.velocity = CGVector(dx: -speed, dy: enemy?.physicsBody?.velocity.dy ?? 0)
            },
            .wait(forDuration: dur)
        ])))
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

        // Era banner
        let eraBg = SKShapeNode(rectOf: CGSize(width: 240, height: 24), cornerRadius: 6)
        eraBg.fillColor   = UIColor.black.withAlphaComponent(0.45)
        eraBg.strokeColor = .clear
        eraBg.position    = CGPoint(x: 0, y: size.height / 2 - 30)
        hud.addChild(eraBg)

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
        bg.fillColor   = UIColor.black.withAlphaComponent(0.55)
        bg.strokeColor = currentCharacter.color
        bg.lineWidth   = 1.5
        container.addChild(bg)

        // Mini character portrait
        let portrait = SKSpriteNode(texture: SpriteFactory.playerTexture(for: currentCharacter))
        portrait.size     = CGSize(width: 22, height: 33)
        portrait.position = CGPoint(x: -36, y: 0)
        container.addChild(portrait)

        let nameLbl = makeHUDLabel(currentCharacter == .bill ? "BILL" : "TED",
                                   fontSize: 18, color: currentCharacter.color)
        nameLbl.position = CGPoint(x: 10, y: 7)
        container.addChild(nameLbl)

        let abilityLbl = makeHUDLabel(currentCharacter.ability, fontSize: 8, color: .lightGray)
        abilityLbl.position = CGPoint(x: 10, y: -11)
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

        leftButton    = controlButton("◀", at: CGPoint(x: leftX,      y: btnY), name: "leftButton")
        rightButton   = controlButton("▶", at: CGPoint(x: leftX + 80, y: btnY), name: "rightButton")
        jumpButton    = controlButton("▲", at: CGPoint(x: size.width / 2 - 68,  y: btnY), name: "jumpButton")
        abilityButton = controlButton("★", at: CGPoint(x: size.width / 2 - 148, y: btnY), name: "abilityButton")

        controls.addChild(leftButton)
        controls.addChild(rightButton)
        controls.addChild(jumpButton)
        controls.addChild(abilityButton)

        switchPrompt = SKLabelNode(text: "▲ SWITCH CHARACTER")
        switchPrompt.fontName = "AvenirNext-Bold"
        switchPrompt.fontSize = 14
        switchPrompt.fontColor = UIColor(red: 0.30, green: 0.90, blue: 1.00, alpha: 1)
        switchPrompt.position  = CGPoint(x: 0, y: -size.height / 2 + 136)
        switchPrompt.isHidden  = true
        controls.addChild(switchPrompt)

        switchPrompt.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.25, duration: 0.5),
            .fadeAlpha(to: 1.00, duration: 0.5)
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
        lbl.verticalAlignmentMode    = .center
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
        for node in cam.nodes(at: locInCam) {
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
                if nearPhoneBooth { switchCharacter() } else { player.jump() }
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

        // Sparkle burst
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
                    .moveBy(x: cos(angle)*dist, y: sin(angle)*dist, duration: 0.4),
                    .fadeOut(withDuration: 0.4)
                ]),
                .removeFromParent()
            ]))
        }

        node.run(.sequence([
            .group([.scale(to: 2, duration: 0.3), .fadeOut(withDuration: 0.3)]),
            .removeFromParent()
        ]))
        showBanner("Socrates collected!  Be excellent! 🤘")
    }

    private func switchCharacter() {
        currentCharacter = currentCharacter == .bill ? .ted : .bill

        let pos     = player.position
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
        let bg = SKShapeNode(rectOf: CGSize(width: 300, height: 32), cornerRadius: 8)
        bg.fillColor   = UIColor.black.withAlphaComponent(0.55)
        bg.strokeColor = .clear
        bg.position    = CGPoint(x: 0, y: size.height / 2 - 80)
        bg.zPosition   = 200
        cam.addChild(bg)

        let lbl = SKLabelNode(text: text)
        lbl.fontName  = "AvenirNext-Bold"
        lbl.fontSize  = 16
        lbl.fontColor = UIColor(red: 1.0, green: 0.88, blue: 0.25, alpha: 1)
        lbl.verticalAlignmentMode = .center
        bg.addChild(lbl)

        bg.run(.sequence([
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
        // Shift parallax layers relative to camera
        let camX = cam.position.x
        farBgNode.position.x  = (camX - levelWidth / 2) * -0.20
        midBgNode.position.x  = (camX - levelWidth / 2) * -0.50
        cloudNode.position.x  = (camX - levelWidth / 2) * -0.30
    }

    private func clampPlayer() {
        player.position.x = player.position.x.clamped(to: 30...(levelWidth - 30))
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
        pb.isDynamic          = false
        pb.friction           = 0.8
        pb.categoryBitMask    = categoryBitMask
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = collisionBitMask
        node.physicsBody      = pb
    }
}

// MARK: - Comparable clamping

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
