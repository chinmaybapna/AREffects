//
//  MotionDetectionViewController.swift
//  AREffects
//
//  Created by Chinmay Bapna on 07/07/20.
//  Copyright © 2020 Chinmay Bapna. All rights reserved.

import UIKit
import RealityKit
import ARKit
import Combine
import ReplayKit

class MotionDetectionViewController: UIViewController, ARSessionDelegate, RPPreviewViewControllerDelegate {
    
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    let recorder = RPScreenRecorder.shared()
    
    var rearCamera = true
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.layer.cornerRadius = 10
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        instructionLabel.isHidden = true
        okButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        
        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        
        //        let mEntity = try! Entity.loadBodyTracked(named: "character/xbot")
        //        mEntity.scale = [1.0, 1.0, 1.0]
        //        self.character = mEntity
        
        
        
        ///*
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
    }
    
    @IBAction func record(_ sender: Any) {
        if !recorder.isRecording {
            recorder.startRecording { error in
                guard error == nil else {
                    print("failed to record")
                    return
                }
            }
            self.recordButton.setImage(UIImage(named: "icons8-rounded-square-96"), for: .normal)
        } else {
            recorder.stopRecording { (previewController, error) in
                guard error == nil else {
                    print("failed to stop")
                    return
                }
                if let previewVC = previewController {
                    self.present(previewVC, animated: true, completion: nil)
                }
            }
            recordButton.setImage(UIImage(named: "icons8-circle-96"), for: .normal)
        }
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: false, completion: nil)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            
            if let character = character, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
        }
    }
}
