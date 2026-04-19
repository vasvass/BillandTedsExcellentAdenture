//  MenuScene.swift
//  BillandTedsExcellentAdventure

import SpriteKit

class MenuScene: SKScene {

    private var selectedCharacter: CharacterType = .bill
    private var billCard: SKNode!
    private var tedCard:  SKNode!

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.04, green: 0.04, blue: 0.10, alpha: 1)
        setupStarfield()
        setupTitle()
        setupCharacterCards()
        setupStartButton()
        updateSelection(animated: false)
    }

    // MARK: - Background

    private func setupStarfield() {
        guard let emitter = SKEmitterNode(fileNamed: "Starfield.sks") else {
            // Fallback: scattered dot particles via code
            for _ in 0..<80 {
                let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.8...2.2))
                star.fillColor = UIColor.white.withAlphaComponent(CGFloat.random(in: 0.3...0.9))
                star.strokeColor = .clear
                star.position = CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                )
                star.zPosition = -1
                addChild(star)

                // Gentle twinkle
                let delay = SKAction.wait(forDuration: Double.random(in: 0...2))
                let fade  = SKAction.sequence([
                    .fadeAlpha(to: 0.1, duration: Double.random(in: 0.8...2.0)),
                    .fadeAlpha(to: 0.9, duration: Double.random(in: 0.8...2.0))
                ])
                star.run(.sequence([delay, .repeatForever(fade)]))
            }
            return
        }
        emitter.position = CGPoint(x: size.width / 2, y: size.height)
        emitter.zPosition = -1
        addChild(emitter)
    }

    // MARK: - Title

    private func setupTitle() {
        let y = size.height - 70

        let line1 = label("BILL & TED'S", size: 36, color: .systemYellow, bold: true)
        line1.position = CGPoint(x: size.width / 2, y: y)
        addChild(line1)

        let line2 = label("EXCELLENT ADVENTURE", size: 26, color: .systemOrange, bold: true)
        line2.position = CGPoint(x: size.width / 2, y: y - 44)
        addChild(line2)

        let tagline = label("Choose Your Dude, Dude", size: 15, color: .lightGray, bold: false)
        tagline.position = CGPoint(x: size.width / 2, y: y - 80)
        addChild(tagline)
    }

    // MARK: - Character cards

    private func setupCharacterCards() {
        billCard = makeCard(for: .bill, at: CGPoint(x: size.width * 0.27, y: size.height / 2 - 30))
        tedCard  = makeCard(for: .ted,  at: CGPoint(x: size.width * 0.73, y: size.height / 2 - 30))
        addChild(billCard)
        addChild(tedCard)
    }

    private func makeCard(for type: CharacterType, at position: CGPoint) -> SKNode {
        let root = SKNode()
        root.position = position
        root.name = type.rawValue

        // Card background
        let bg = SKShapeNode(rectOf: CGSize(width: 145, height: 230), cornerRadius: 16)
        bg.fillColor = UIColor(white: 0.1, alpha: 1)
        bg.strokeColor = type.color
        bg.lineWidth = 2
        bg.name = type.rawValue + "_bg"
        root.addChild(bg)

        // Avatar — drawn character portrait
        let avatar = SKSpriteNode(texture: SpriteFactory.playerTexture(for: type))
        avatar.size = CGSize(width: 56, height: 84)
        avatar.position = CGPoint(x: 0, y: 45)
        root.addChild(avatar)

        // Name
        let nameLabel = label(type == .bill ? "BILL" : "TED", size: 22, color: type.color, bold: true)
        nameLabel.position = CGPoint(x: 0, y: -18)
        root.addChild(nameLabel)

        // Stats
        for (i, text) in ["Jump:  \(type.jumpStars)", "Speed: \(type.speedStars)"].enumerated() {
            let stat = label(text, size: 11, color: .lightGray, bold: false)
            stat.fontName = "Courier-Bold"
            stat.position = CGPoint(x: 0, y: -46 - CGFloat(i * 20))
            root.addChild(stat)
        }

        // Ability
        let abilityLabel = label(type.ability, size: 10, color: .systemYellow, bold: false)
        abilityLabel.position = CGPoint(x: 0, y: -96)
        root.addChild(abilityLabel)

        return root
    }

    // MARK: - Start button

    private func setupStartButton() {
        let btn = SKLabelNode(text: "[ MOST EXCELLENT START ]")
        btn.fontName = "AvenirNext-Heavy"
        btn.fontSize = 22
        btn.fontColor = .systemGreen
        btn.position = CGPoint(x: size.width / 2, y: 90)
        btn.name = "startButton"
        addChild(btn)

        btn.run(.repeatForever(.sequence([
            .fadeAlpha(to: 0.3, duration: 0.65),
            .fadeAlpha(to: 1.0, duration: 0.65)
        ])))
    }

    // MARK: - Selection feedback

    private func updateSelection(animated: Bool) {
        let dur: TimeInterval = animated ? 0.18 : 0

        for (card, type) in [(billCard!, CharacterType.bill), (tedCard!, CharacterType.ted)] {
            let selected = selectedCharacter == type
            card.run(.scale(to: selected ? 1.08 : 0.90, duration: dur))

            if let bg = card.childNode(withName: type.rawValue + "_bg") as? SKShapeNode {
                bg.strokeColor = selected ? type.color : UIColor(white: 0.25, alpha: 1)
                bg.lineWidth   = selected ? 3 : 1.5
            }
        }
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for node in nodes(at: location) {
            let resolvedName = resolvedCardName(for: node)

            if resolvedName == CharacterType.bill.rawValue {
                selectedCharacter = .bill
                updateSelection(animated: true)
                return
            }
            if resolvedName == CharacterType.ted.rawValue {
                selectedCharacter = .ted
                updateSelection(animated: true)
                return
            }
            if node.name == "startButton" {
                startGame()
                return
            }
        }
    }

    // Walk up to 4 parent levels to find a card name
    private func resolvedCardName(for node: SKNode) -> String? {
        var current: SKNode? = node
        for _ in 0..<4 {
            if let name = current?.name,
               CharacterType.allCases.map({ $0.rawValue }).contains(name) {
                return name
            }
            current = current?.parent
        }
        return nil
    }

    // MARK: - Transition

    private func startGame() {
        let scene = GameScene(size: size, character: selectedCharacter)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: .fade(withDuration: 1.0))
    }

    // MARK: - Helpers

    private func label(_ text: String, size fontSize: CGFloat, color: UIColor, bold: Bool) -> SKLabelNode {
        let node = SKLabelNode(text: text)
        node.fontName = bold ? "AvenirNext-Bold" : "AvenirNext-Medium"
        node.fontSize = fontSize
        node.fontColor = color
        node.horizontalAlignmentMode = .center
        node.verticalAlignmentMode   = .center
        return node
    }
}
