//  SanDimasScene.swift
//  BillandTedsExcellentAdventure
//
//  Stage 1: San Dimas High School
//  Bill & Ted receive their history report assignment from Mr. Ryan,
//  then discover the phone booth in the parking lot.

import SpriteKit

// MARK: - Dialog data

private struct DialogLine {
    enum Speaker { case teacher, bill, ted }
    let speaker: Speaker
    let text: String
}

private let assignmentDialog: [DialogLine] = [
    .init(speaker: .teacher, text: "Bill! Ted! Pay attention up front!"),
    .init(speaker: .teacher, text: "Your history report is due this FRIDAY."),
    .init(speaker: .teacher, text: "Present 7 historical figures to the class."),
    .init(speaker: .teacher, text: "Fail this... and you WILL repeat the year."),
    .init(speaker: .bill,    text: "Whoa. Dude. This is most non-triumphant."),
    .init(speaker: .ted,     text: "We are in serious trouble, Bill. Bogus!"),
    .init(speaker: .bill,    text: "Don't worry, Ted. I have a most excellent idea..."),
]

// MARK: - Scene

class SanDimasScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Layout constants

    private let levelWidth: CGFloat = 1900
    private let groundTopY: CGFloat = 80

    // Zone x-boundaries
    private let exteriorEnd:  CGFloat = 420
    private let classroomX:   CGFloat = 1050
    private let parkingLotX:  CGFloat = 1480
    private let boothX:       CGFloat = 1720

    // MARK: - Properties

    private var player:   PlayerNode!
    private var cam:      SKCameraNode!
    private var controls: SKNode!

    private var leftButton:  SKShapeNode!
    private var rightButton: SKShapeNode!
    private var jumpButton:  SKShapeNode!
    private var leftTouchID:  UITouch?
    private var rightTouchID: UITouch?

    private var currentCharacter: CharacterType
    private var supportingGroundBodies = Set<ObjectIdentifier>()

    // Dialog
    private var dialogActive     = false
    private var dialogIndex      = 0
    private var dialogPanel:     SKNode?
    private var dialogTriggered  = false

    // Progress
    private var assignmentDone   = false
    private var levelComplete    = false

    // MARK: - Init

    init(size: CGSize, character: CharacterType) {
        self.currentCharacter = character
        super.init(size: size)
    }

    required init?(coder: NSCoder) {
        self.currentCharacter = .bill
        super.init(coder: coder)
    }

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.65, green: 0.82, blue: 0.96, alpha: 1)
        physicsWorld.gravity         = CGVector(dx: 0, dy: -18)
        physicsWorld.contactDelegate = self

        setupCamera()
        buildBackground()
        buildLevel()
        setupPlayer()
        cam.position = CGPoint(x: player.position.x.clamped(to: size.width/2...(levelWidth - size.width/2)),
                               y: size.height / 2)
        setupControls()
        showOpeningTitle()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard oldSize != size, controls != nil else { return }
        repositionControls()
    }

    // MARK: - Camera

    private func setupCamera() {
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
    }

    // MARK: - Opening title

    private func showOpeningTitle() {
        let overlay = SKNode()
        overlay.zPosition = 200

        let bg = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        bg.fillColor   = UIColor.black.withAlphaComponent(0.70)
        bg.strokeColor = .clear
        overlay.addChild(bg)

        let location = makeLabel("San Dimas, California — 1988", fontSize: 15, color: .lightGray)
        location.position = CGPoint(x: 0, y: 30)
        overlay.addChild(location)

        let title = makeLabel("San Dimas High School", fontSize: 26, color: .white, bold: true)
        title.position = CGPoint(x: 0, y: -10)
        overlay.addChild(title)

        let hint = makeLabel("Tap to continue", fontSize: 13, color: UIColor.white.withAlphaComponent(0.55))
        hint.position = CGPoint(x: 0, y: -60)
        hint.run(.repeatForever(.sequence([.fadeAlpha(to: 0.2, duration: 0.6),
                                            .fadeAlpha(to: 1.0, duration: 0.6)])))
        overlay.addChild(hint)

        cam.addChild(overlay)

        // Dismiss on tap after short delay
        overlay.run(.sequence([
            .wait(forDuration: 1.0),
            .run { overlay.name = "openingOverlay" }
        ]))
    }

    // MARK: - Background

    private func buildBackground() {
        addExterior()
        addInterior()
        addParkingLot()
    }

    private func addExterior() {
        // School building exterior fills first zone
        let extW = exteriorEnd + 100
        let extH = max(size.height * 1.5, 600)
        let tex  = SpriteFactory.schoolExteriorTexture(size: CGSize(width: extW, height: extH))
        let ext  = SKSpriteNode(texture: tex)
        ext.size     = CGSize(width: extW, height: extH)
        ext.position = CGPoint(x: extW / 2, y: groundTopY + extH / 2 - 40)
        ext.zPosition = -10
        addChild(ext)
    }

    private func addInterior() {
        // Hallway spans from school entrance to parking lot
        let hallW = parkingLotX - exteriorEnd + 80
        let hallH = max(size.height, 500)

        // Ceiling — dark grey
        let ceiling = SKSpriteNode(color: UIColor(red: 0.52, green: 0.52, blue: 0.54, alpha: 1),
                                   size: CGSize(width: hallW, height: hallH * 0.30))
        ceiling.position = CGPoint(x: exteriorEnd + hallW / 2,
                                   y: groundTopY + hallH * 0.85)
        ceiling.zPosition = -11
        addChild(ceiling)

        // Fluorescent light strips on ceiling
        let lightCount = Int(hallW / 160)
        for i in 0..<lightCount {
            let lx = exteriorEnd + 80 + CGFloat(i) * 160
            let light = SKShapeNode(rectOf: CGSize(width: 100, height: 10), cornerRadius: 3)
            light.fillColor   = UIColor(red: 0.98, green: 0.96, blue: 0.88, alpha: 0.95)
            light.strokeColor = .clear
            light.position    = CGPoint(x: lx, y: groundTopY + hallH * 0.85)
            light.zPosition   = -9

            // Soft downward glow
            let glow = SKShapeNode(rectOf: CGSize(width: 120, height: 180))
            glow.fillColor   = UIColor(red: 0.98, green: 0.96, blue: 0.88, alpha: 0.06)
            glow.strokeColor = .clear
            glow.position    = CGPoint(x: 0, y: -90)
            light.addChild(glow)
            addChild(light)
        }

        // Wall above lockers
        let wallAbove = SKSpriteNode(color: UIColor(red: 0.82, green: 0.80, blue: 0.76, alpha: 1),
                                     size: CGSize(width: hallW, height: hallH * 0.20))
        wallAbove.position = CGPoint(x: exteriorEnd + hallW / 2,
                                     y: groundTopY + hallH * 0.58)
        wallAbove.zPosition = -11
        addChild(wallAbove)

        // Locker banks along the wall
        let lockerH: CGFloat = 110
        let lockerUnitW: CGFloat = 200
        var lx = exteriorEnd + 40
        while lx < parkingLotX - 40 {
            let tex = SpriteFactory.lockerBankTexture(size: CGSize(width: lockerUnitW * 2, height: lockerH * 2))
            let bank = SKSpriteNode(texture: tex)
            bank.size     = CGSize(width: lockerUnitW, height: lockerH)
            bank.position = CGPoint(x: lx + lockerUnitW / 2, y: groundTopY + lockerH / 2)
            bank.zPosition = -8
            addChild(bank)
            lx += lockerUnitW + 20
        }

        // Chalkboard at classroom
        let cbW: CGFloat = 240, cbH: CGFloat = 140
        let cbTex = SpriteFactory.chalkboardTexture(size: CGSize(width: cbW * 2, height: cbH * 2))
        let cb = SKSpriteNode(texture: cbTex)
        cb.size     = CGSize(width: cbW, height: cbH)
        cb.position = CGPoint(x: classroomX + 60, y: groundTopY + lockerH + cbH / 2 + 10)
        cb.zPosition = -7
        addChild(cb)

        // "Mr. Ryan" name plate above chalkboard
        let plate = SKLabelNode(text: "Mr. Ryan — History")
        plate.fontName  = "AvenirNext-Medium"
        plate.fontSize  = 11
        plate.fontColor = UIColor(red: 0.85, green: 0.82, blue: 0.70, alpha: 0.90)
        plate.position  = CGPoint(x: classroomX + 60, y: groundTopY + lockerH + cbH + 22)
        plate.zPosition = -6
        addChild(plate)
    }

    private func addParkingLot() {
        let lotW = levelWidth - parkingLotX + 100
        let lotH = max(size.height * 1.5, 600)

        // Sky
        let sky = SKSpriteNode(color: UIColor(red: 0.65, green: 0.82, blue: 0.96, alpha: 1),
                               size: CGSize(width: lotW, height: lotH))
        sky.position  = CGPoint(x: parkingLotX + lotW / 2, y: groundTopY + lotH / 2)
        sky.zPosition = -12
        addChild(sky)

        // Asphalt ground cover
        let asphalt = SKSpriteNode(color: UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1),
                                   size: CGSize(width: lotW, height: 100))
        asphalt.position  = CGPoint(x: parkingLotX + lotW / 2, y: groundTopY - 10)
        asphalt.zPosition = -9
        addChild(asphalt)

        // Parking space lines
        var px = parkingLotX + 50
        while px < levelWidth - 100 {
            let line = SKSpriteNode(color: UIColor(red: 0.90, green: 0.88, blue: 0.82, alpha: 0.6),
                                    size: CGSize(width: 2, height: 50))
            line.position  = CGPoint(x: px, y: groundTopY + 20)
            line.zPosition = -8
            addChild(line)
            px += 80
        }

        // Arrow sign pointing to booth (appears after dialog)
        let arrow = SKLabelNode(text: "→ Phone Booth")
        arrow.fontName  = "AvenirNext-Bold"
        arrow.fontSize  = 14
        arrow.fontColor = UIColor(red: 0.30, green: 0.90, blue: 1.00, alpha: 1)
        arrow.position  = CGPoint(x: boothX - 120, y: groundTopY + 90)
        arrow.zPosition = 5
        arrow.name      = "boothArrow"
        arrow.alpha     = 0
        addChild(arrow)
    }

    // MARK: - Level objects

    private func buildLevel() {
        addGround()
        addTeacher()
        addPhoneBooth()
        addDialogTrigger()
    }

    private func addGround() {
        let floorH: CGFloat = 60

        // Exterior sidewalk strip
        let extGround = SKSpriteNode(color: UIColor(red: 0.76, green: 0.74, blue: 0.70, alpha: 1),
                                     size: CGSize(width: exteriorEnd + 100, height: floorH))
        extGround.position = CGPoint(x: (exteriorEnd + 100) / 2, y: groundTopY - floorH / 2)
        applyGround(to: extGround)
        addChild(extGround)

        // Interior school floor (checkered tile)
        let intW = parkingLotX - exteriorEnd + 80
        let intFloorTex = SpriteFactory.schoolFloorTexture(size: CGSize(width: 200, height: floorH * 2))
        let intGround = SKSpriteNode(texture: intFloorTex)
        intGround.size     = CGSize(width: intW, height: floorH)
        intGround.position = CGPoint(x: exteriorEnd + intW / 2, y: groundTopY - floorH / 2)
        applyGround(to: intGround)
        addChild(intGround)

        // Parking lot asphalt ground
        let lotW = levelWidth - parkingLotX + 200
        let lotGround = SKSpriteNode(color: UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1),
                                     size: CGSize(width: lotW, height: floorH))
        lotGround.position = CGPoint(x: parkingLotX + lotW / 2 - 80, y: groundTopY - floorH / 2)
        applyGround(to: lotGround)
        addChild(lotGround)
    }

    private func addTeacher() {
        let size = CGSize(width: 36, height: 55)
        let teacher = SKSpriteNode(texture: SpriteFactory.teacherTexture())
        teacher.size     = size
        teacher.position = CGPoint(x: classroomX + 80, y: groundTopY + size.height / 2)
        teacher.zPosition = 3
        teacher.name     = "teacher"
        // Teacher faces left (toward player)
        teacher.xScale = -1
        addChild(teacher)

        // Subtle idle bob
        teacher.run(.repeatForever(.sequence([
            .moveBy(x: 0, y: 2, duration: 1.2),
            .moveBy(x: 0, y: -2, duration: 1.2)
        ])))
    }

    private func addPhoneBooth() {
        let boothSize = CGSize(width: 52, height: 96)
        let booth = SKSpriteNode(texture: SpriteFactory.phoneBoothTexture())
        booth.size     = boothSize
        booth.position = CGPoint(x: boothX, y: groundTopY + boothSize.height / 2)
        booth.name     = "phoneBooth"
        booth.zPosition = 3
        // Initially dim — revealed after assignment
        booth.alpha    = 0.30

        let pb = SKPhysicsBody(rectangleOf: boothSize)
        pb.isDynamic          = false
        pb.categoryBitMask    = PhysicsCategory.phoneBooth
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.none
        booth.physicsBody     = pb

        let glow = SKShapeNode(ellipseOf: CGSize(width: 70, height: 14))
        glow.fillColor   = UIColor(red: 0.10, green: 0.50, blue: 1.00, alpha: 0.0)
        glow.strokeColor = .clear
        glow.position    = CGPoint(x: boothX, y: groundTopY + 4)
        glow.zPosition   = 2
        glow.name        = "boothGlow"
        addChild(glow)
        addChild(booth)
    }

    private func addDialogTrigger() {
        // Invisible trigger zone just before the teacher
        let triggerSize = CGSize(width: 60, height: 120)
        let trigger = SKSpriteNode(color: .clear, size: triggerSize)
        trigger.position  = CGPoint(x: classroomX - 10, y: groundTopY + 60)
        trigger.zPosition = 1
        trigger.name      = "dialogTrigger"

        let pb = SKPhysicsBody(rectangleOf: triggerSize)
        pb.isDynamic          = false
        pb.categoryBitMask    = PhysicsCategory.trigger
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.none
        trigger.physicsBody   = pb
        addChild(trigger)
    }

    // MARK: - Player

    private func setupPlayer() {
        player = PlayerNode(characterType: currentCharacter)
        player.position  = CGPoint(x: 80, y: groundTopY + 60)
        player.zPosition = 10
        addChild(player)
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
        leftButton  = controlBtn("◀", at: CGPoint(x: leftX,      y: btnY), name: "left")
        rightButton = controlBtn("▶", at: CGPoint(x: leftX + 80, y: btnY), name: "right")
        jumpButton  = controlBtn("▲", at: CGPoint(x: size.width / 2 - 68, y: btnY), name: "jump")
        controls.addChild(leftButton)
        controls.addChild(rightButton)
        controls.addChild(jumpButton)
    }

    private func controlBtn(_ sym: String, at pos: CGPoint, name: String) -> SKShapeNode {
        let btn = SKShapeNode(circleOfRadius: 30)
        btn.fillColor   = UIColor.white.withAlphaComponent(0.18)
        btn.strokeColor = UIColor.white.withAlphaComponent(0.45)
        btn.lineWidth   = 1.5
        btn.position    = pos
        btn.name        = name
        let lbl = SKLabelNode(text: sym)
        lbl.fontName = "AvenirNext-Bold"; lbl.fontSize = 22; lbl.fontColor = .white
        lbl.verticalAlignmentMode = .center; lbl.isUserInteractionEnabled = false
        btn.addChild(lbl)
        return btn
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        // Dismiss opening overlay on first tap
        if let opening = cam.childNode(withName: "openingOverlay") {
            opening.removeFromParent()
            return
        }

        // Advance dialog
        if dialogActive {
            advanceDialog()
            return
        }

        let loc = touch.location(in: cam)
        for node in cam.nodes(at: loc) {
            let name = node.name ?? node.parent?.name ?? ""
            switch name {
            case "left":  leftTouchID = touch; player.isMovingLeft  = true;  leftButton.fillColor  = UIColor.white.withAlphaComponent(0.38)
            case "right": rightTouchID = touch; player.isMovingRight = true; rightButton.fillColor = UIColor.white.withAlphaComponent(0.38)
            case "jump":  player.jump()
            default: break
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch === leftTouchID  { leftTouchID  = nil; player.isMovingLeft  = false; leftButton.fillColor  = UIColor.white.withAlphaComponent(0.18) }
            if touch === rightTouchID { rightTouchID = nil; player.isMovingRight = false; rightButton.fillColor = UIColor.white.withAlphaComponent(0.18) }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        leftTouchID = nil; rightTouchID = nil
        player.isMovingLeft = false; player.isMovingRight = false
    }

    // MARK: - Dialog system

    private func startDialog() {
        guard !dialogTriggered else { return }
        dialogTriggered = true
        dialogActive    = true
        dialogIndex     = 0

        // Freeze player
        player.isMovingLeft  = false
        player.isMovingRight = false
        player.physicsBody?.velocity.dx = 0

        showDialogLine(assignmentDialog[0])
    }

    private func advanceDialog() {
        dialogIndex += 1
        if dialogIndex < assignmentDialog.count {
            showDialogLine(assignmentDialog[dialogIndex])
        } else {
            endDialog()
        }
    }

    private func showDialogLine(_ line: DialogLine) {
        dialogPanel?.removeFromParent()

        let panel = SKNode()
        panel.zPosition = 300

        // Background
        let panelW = min(size.width - 40, 360)
        let panelH: CGFloat = 100
        let bg = SKShapeNode(rectOf: CGSize(width: panelW, height: panelH), cornerRadius: 12)
        bg.fillColor   = UIColor.black.withAlphaComponent(0.80)
        bg.strokeColor = speakerColor(line.speaker).withAlphaComponent(0.80)
        bg.lineWidth   = 2
        bg.position    = CGPoint(x: 0, y: -size.height / 2 + panelH / 2 + 90)
        panel.addChild(bg)

        // Portrait
        let portrait = portraitNode(for: line.speaker)
        portrait.size     = CGSize(width: 44, height: 66)
        portrait.position = CGPoint(x: -panelW / 2 + 34, y: bg.position.y)
        panel.addChild(portrait)

        // Speaker name
        let nameLabel = makeLabel(speakerName(line.speaker), fontSize: 12,
                                  color: speakerColor(line.speaker), bold: true)
        nameLabel.position = CGPoint(x: -panelW / 2 + 90, y: bg.position.y + 28)
        nameLabel.horizontalAlignmentMode = .left
        panel.addChild(nameLabel)

        // Dialog text
        let textLabel = SKLabelNode(text: line.text)
        textLabel.fontName               = "AvenirNext-Medium"
        textLabel.fontSize               = 14
        textLabel.fontColor              = .white
        textLabel.numberOfLines          = 2
        textLabel.preferredMaxLayoutWidth = panelW - 90
        textLabel.horizontalAlignmentMode = .left
        textLabel.verticalAlignmentMode   = .center
        textLabel.position = CGPoint(x: -panelW / 2 + 90, y: bg.position.y - 8)
        panel.addChild(textLabel)

        // Tap hint
        let hint = makeLabel("▶ tap", fontSize: 10,
                             color: UIColor.white.withAlphaComponent(0.45))
        hint.position = CGPoint(x: panelW / 2 - 24, y: bg.position.y - 32)
        hint.run(.repeatForever(.sequence([.fadeAlpha(to: 0.2, duration: 0.5),
                                            .fadeAlpha(to: 1.0, duration: 0.5)])))
        panel.addChild(hint)

        cam.addChild(panel)
        dialogPanel = panel

        // Pop-in animation
        panel.setScale(0.85); panel.alpha = 0
        panel.run(.group([.scale(to: 1.0, duration: 0.15), .fadeIn(withDuration: 0.15)]))
    }

    private func endDialog() {
        dialogActive   = false
        assignmentDone = true
        dialogPanel?.removeFromParent()
        dialogPanel = nil

        // Reveal phone booth with animation
        revealPhoneBooth()

        // Show arrow hint
        childNode(withName: "boothArrow")?.run(.sequence([
            .wait(forDuration: 0.5),
            .fadeIn(withDuration: 0.4)
        ]))

        // Show banner
        showBanner("Find the phone booth in the parking lot!")
    }

    private func revealPhoneBooth() {
        guard let booth = childNode(withName: "phoneBooth") as? SKSpriteNode,
              let glow  = childNode(withName: "boothGlow")  as? SKShapeNode else { return }

        booth.run(.sequence([
            .wait(forDuration: 0.3),
            .group([
                .fadeAlpha(to: 1.0, duration: 0.8),
                .sequence([
                    .scale(to: 1.08, duration: 0.3),
                    .scale(to: 1.00, duration: 0.2)
                ])
            ])
        ]))
        glow.run(.sequence([
            .wait(forDuration: 0.3),
            .fadeAlpha(to: 0.40, duration: 0.8)
        ]))
        booth.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.75, duration: 1.2),
            .fadeAlpha(to: 1.00, duration: 1.2)
        ])), withKey: "pulse")
    }

    // MARK: - Speaker helpers

    private func speakerName(_ speaker: DialogLine.Speaker) -> String {
        switch speaker {
        case .teacher: return "Mr. Ryan"
        case .bill:    return "Bill"
        case .ted:     return "Ted"
        }
    }

    private func speakerColor(_ speaker: DialogLine.Speaker) -> UIColor {
        switch speaker {
        case .teacher: return UIColor(red: 0.90, green: 0.72, blue: 0.20, alpha: 1)
        case .bill:    return UIColor(red: 0.30, green: 0.55, blue: 1.00, alpha: 1)
        case .ted:     return UIColor(red: 1.00, green: 0.35, blue: 0.35, alpha: 1)
        }
    }

    private func portraitNode(for speaker: DialogLine.Speaker) -> SKSpriteNode {
        switch speaker {
        case .teacher: return SKSpriteNode(texture: SpriteFactory.teacherTexture())
        case .bill:    return SKSpriteNode(texture: SpriteFactory.playerTexture(for: .bill))
        case .ted:     return SKSpriteNode(texture: SpriteFactory.playerTexture(for: .ted))
        }
    }

    // MARK: - Physics

    func didBegin(_ contact: SKPhysicsContact) {
        let masks = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)

        // Ground landing
        if let pair = groundPair(contact), isSupportingContact(contact) {
            supportingGroundBodies.insert(ObjectIdentifier(pair.ground))
            player.isOnGround = true
            player.jumpCount  = 0
        }

        // Dialog trigger
        if masks == (PhysicsCategory.player, PhysicsCategory.trigger) ||
           masks == (PhysicsCategory.trigger, PhysicsCategory.player) {
            startDialog()
        }

        // Phone booth — only after assignment received
        if (masks == (PhysicsCategory.player, PhysicsCategory.phoneBooth) ||
            masks == (PhysicsCategory.phoneBooth, PhysicsCategory.player)),
           assignmentDone, !levelComplete {
            triggerAdventure()
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if let pair = groundPair(contact) {
            supportingGroundBodies.remove(ObjectIdentifier(pair.ground))
            player.isOnGround = !supportingGroundBodies.isEmpty
        }
    }

    private func groundPair(_ contact: SKPhysicsContact)
        -> (player: SKPhysicsBody, ground: SKPhysicsBody)? {
        if contact.bodyA.categoryBitMask == PhysicsCategory.player &&
           contact.bodyB.categoryBitMask == PhysicsCategory.ground { return (contact.bodyA, contact.bodyB) }
        if contact.bodyA.categoryBitMask == PhysicsCategory.ground &&
           contact.bodyB.categoryBitMask == PhysicsCategory.player { return (contact.bodyB, contact.bodyA) }
        return nil
    }

    private func isSupportingContact(_ contact: SKPhysicsContact) -> Bool {
        guard let pair = groundPair(contact) else { return false }
        return pair.player == contact.bodyA
            ? contact.contactNormal.dy < -0.5
            : contact.contactNormal.dy >  0.5
    }

    // MARK: - Level complete: travel to Ancient Greece

    private func triggerAdventure() {
        guard !levelComplete else { return }
        levelComplete = true
        player.isMovingLeft = false; player.isMovingRight = false
        player.physicsBody?.isDynamic = false

        // Flash white — "time travel" effect
        let flash = SKShapeNode(rectOf: CGSize(width: size.width * 3, height: size.height * 3))
        flash.fillColor   = .white
        flash.strokeColor = .clear
        flash.zPosition   = 500
        flash.alpha       = 0
        cam.addChild(flash)

        flash.run(.sequence([
            .fadeAlpha(to: 1.0, duration: 0.4),
            .wait(forDuration: 0.3),
            .run { [weak self] in
                guard let self else { return }
                let next = GameScene(size: self.size, character: self.currentCharacter)
                next.scaleMode = .aspectFill
                self.view?.presentScene(next, transition: .fade(withDuration: 0.5))
            }
        ]))
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
        lbl.fontSize  = 13
        lbl.fontColor = UIColor(red: 1.0, green: 0.88, blue: 0.25, alpha: 1)
        lbl.verticalAlignmentMode = .center
        bg.addChild(lbl)

        bg.run(.sequence([.wait(forDuration: 3.0), .fadeOut(withDuration: 0.5), .removeFromParent()]))
    }

    // MARK: - Update

    override func update(_ currentTime: TimeInterval) {
        guard !levelComplete, !dialogActive else { return }
        player.update(deltaTime: 0)
        updateCamera()
        clampPlayer()
    }

    private func updateCamera() {
        let halfW = size.width / 2
        let targetX = player.position.x.clamped(to: halfW...(levelWidth - halfW))
        let targetY = max(size.height / 2, player.position.y + 80)
        let t: CGFloat = 0.12
        cam.position.x += (targetX - cam.position.x) * t
        cam.position.y += (targetY - cam.position.y) * t
    }

    private func clampPlayer() {
        player.position.x = player.position.x.clamped(to: 30...(levelWidth - 30))
        if player.position.y < -200 {
            player.position = CGPoint(x: 80, y: groundTopY + 60)
            player.physicsBody?.velocity = .zero
        }
    }

    // MARK: - Physics helper

    private func applyGround(to node: SKSpriteNode) {
        let pb = SKPhysicsBody(rectangleOf: node.size)
        pb.isDynamic          = false
        pb.friction           = 0.8
        pb.categoryBitMask    = PhysicsCategory.ground
        pb.contactTestBitMask = PhysicsCategory.player
        pb.collisionBitMask   = PhysicsCategory.player
        node.physicsBody      = pb
    }

    // MARK: - Label helper

    private func makeLabel(_ text: String, fontSize: CGFloat,
                            color: UIColor, bold: Bool = false) -> SKLabelNode {
        let lbl = SKLabelNode(text: text)
        lbl.fontName  = bold ? "AvenirNext-Bold" : "AvenirNext-Medium"
        lbl.fontSize  = fontSize
        lbl.fontColor = color
        lbl.horizontalAlignmentMode = .center
        lbl.verticalAlignmentMode   = .center
        return lbl
    }
}
