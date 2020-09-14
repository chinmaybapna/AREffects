//
//  ViewController.swift
//  AREffects
//
//  Created by Chinmay Bapna on 06/07/20.
//  Copyright © 2020 Chinmay Bapna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bollywoodDialogueButton: UIButton!
    @IBOutlet weak var dancingAnimationButton: UIButton!
    @IBOutlet weak var aeroplaneAnimationButton: UIButton!
    @IBOutlet weak var disintegrationEffectButton: UIButton!
    @IBOutlet weak var bodyDetectionButton: UIButton!
    @IBOutlet weak var portalAnimationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bollywoodDialogueButton.layer.cornerRadius = 15
        bollywoodDialogueButton.clipsToBounds = true
        bollywoodDialogueButton.applyGradient(colours: [UIColor(hex: 0xFFD13B), UIColor(hex: 0xFF3F3F)])
        
        aeroplaneAnimationButton.layer.cornerRadius = 15
        aeroplaneAnimationButton.clipsToBounds = true
        aeroplaneAnimationButton.applyGradient(colours: [UIColor(hex: 0x536CCA), UIColor(hex: 0x738EFF)])
        
        dancingAnimationButton.layer.cornerRadius = 15
        dancingAnimationButton.clipsToBounds = true
        dancingAnimationButton.applyGradient(colours: [UIColor(hex: 0x8EC5FC), UIColor(hex: 0xB174EC)])
        
        disintegrationEffectButton.layer.cornerRadius = 15
        disintegrationEffectButton.clipsToBounds = true
        disintegrationEffectButton.applyGradient(colours: [UIColor(hex: 0x5CF3A2), UIColor(hex: 0x8EF281), UIColor(hex: 0xBEF262)])
        
        bodyDetectionButton.layer.cornerRadius = 15
        bodyDetectionButton.clipsToBounds = true
        bodyDetectionButton.applyGradient(colours: [UIColor(hex: 0xFC466B), UIColor(hex: 0x3F5EFB)])
        
        portalAnimationButton.layer.cornerRadius = 15
        portalAnimationButton.clipsToBounds = true
        portalAnimationButton.applyGradient(colours: [UIColor(hex: 0xFFB18A), UIColor(hex: 0xE2565A)])
    }
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}


