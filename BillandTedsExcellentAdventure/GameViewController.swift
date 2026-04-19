//  GameViewController.swift
//  BillandTedsExcellentAdventure

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let skView = view as? SKView else { return }

        let scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill

        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS       = false
        skView.showsNodeCount = false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }

    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }
}
