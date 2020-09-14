//
//  DancingAnimationOptionsViewController.swift
//  AREffects
//
//  Created by Chinmay Bapna on 17/07/20.
//  Copyright © 2020 Chinmay Bapna. All rights reserved.
//

import UIKit

class DancingAnimationOptionsViewController: UIViewController {

    @IBOutlet weak var dance1Button: UIButton!
    @IBOutlet weak var dance2Button: UIButton!
    @IBOutlet weak var dance3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dance1Button.layer.cornerRadius = 15
        dance1Button.clipsToBounds = true
        dance1Button.applyGradient(colours: [UIColor(hex: 0x1BFFFF), UIColor(hex: 0x2E3192)])
        
        dance2Button.layer.cornerRadius = 15
        dance2Button.clipsToBounds = true
        dance2Button.applyGradient(colours: [UIColor(hex: 0xFCEE21), UIColor(hex: 0xED1C24)])
        
        dance3Button.layer.cornerRadius = 15
        dance3Button.clipsToBounds = true
        dance3Button.applyGradient(colours: [UIColor(hex: 0xFCEE21), UIColor(hex: 0x009245)])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dance1" {
            let vc = segue.destination as! DancingAnimationViewController
            vc.animationPath = "art.scnassets/HipHopDancing/HipHopDancing.dae"
        }
        
        else if segue.identifier == "dance2" {
            let vc = segue.destination as! DancingAnimationViewController
            vc.animationPath = "art.scnassets/SalsaDancing/SalsaDancing.dae"
        }
        
        else if segue.identifier == "dance3" {
            let vc = segue.destination as! DancingAnimationViewController
            vc.animationPath = "art.scnassets/Shuffling/Shuffling.dae"
        }
    }
}
