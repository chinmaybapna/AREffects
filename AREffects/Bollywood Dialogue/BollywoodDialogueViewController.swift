//
//  BollywoodDialogueViewController.swift
//  AREffects
//
//  Created by Chinmay Bapna on 06/07/20.
//  Copyright © 2020 Chinmay Bapna. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ReplayKit

class BollywoodDialogueViewController: UIViewController, ARSCNViewDelegate {

    //@IBOutlet weak var recordButton: UIButton!
    let recorder = RPScreenRecorder.shared()
    var progressTimer : Timer!
    var progress : CGFloat! = 0
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.layer.cornerRadius = 10
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(BollywoodDialogueViewController.scaleObject))
        self.view.addGestureRecognizer(pinchRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BollywoodDialogueViewController.moveObject))
        self.view.addGestureRecognizer(panRecognizer)
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        okButton.isHidden = true
        instructionLabel.isHidden = true
        imageView.image = UIImage.gifImageWithName("123")
    }
    
    @IBAction func record(_ sender: Any) {
        if !recorder.isRecording {
            startRecording()
            recordButton.setImage(UIImage(named: "icons8-rounded-square-96"), for: .normal)
        } else {
            endRecording()
        }
    }
    
    func startRecording() {
        recorder.startRecording { error in
            guard error == nil else {
                print("failed to record")
                return
            }
        }
    }
    
    func endRecording() {
        recorder.stopRecording { (previewController, error) in
            guard error == nil else {
                print("failed to stop")
                return
            }
            if let previewVC = previewController {
                self.present(previewVC, animated: true, completion: nil)
            }
        }
    }
    
        
    
//    @IBAction func record(_ sender: Any) {
//        if !recorder.isRecording {
//            recorder.startRecording { error in
//                guard error == nil else {
//                    print("failed to record")
//                    return
//                }
//                self.recordButton.backgroundColor = UIColor.red
//                self.recordButton.setTitle("stop", for: .normal)
//            }
//        } else {
//            recorder.stopRecording { (previewController, error) in
//                guard error == nil else {
//                    print("failed to stop")
//                    return
//                }
//                if let previewVC = previewController {
//                    self.present(previewVC, animated: true, completion: nil)
//                }
//            }
//            self.recordButton.backgroundColor = UIColor.black
//            self.recordButton.setTitle("start", for: .normal)
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        sceneView.removeFromSuperview()
        sceneView = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @objc func scaleObject(gesture: UIPinchGestureRecognizer) {
        imageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }
    
    @objc func moveObject(gesture: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(imageView)
        let translation = gesture.translation(in: self.view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
}
