//
//  PortalAnimationViewController.swift
//  AREffects
//
//  Created by Chinmay Bapna on 20/07/20.
//  Copyright © 2020 Chinmay Bapna. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARVideoKit

class PortalAnimationViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var recorder : RecordAR?

    var isRecording = false
    
    let node = SCNNode()
    
    var rearCamera = true
    
    var animations = [String: CAAnimation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.layer.cornerRadius = 10
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        recorder = RecordAR(ARSceneKit: sceneView)
        
        loadAnimations()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        instructionLabel.isHidden = true
        okButton.isHidden = true
    }
    
    @IBAction func rotateCamera(_ sender: Any) {
        if(rearCamera) {
            let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration)
            rearCamera = false
        } else {
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)
            rearCamera = true
        }
    }
    
    @IBAction func record(_ sender: Any) {
        if(!isRecording) {
            self.recorder?.record()
            recordButton.setImage(UIImage(named: "icons8-rounded-square-96"), for: .normal)
            isRecording = true
        } else {
            print("stop")
            self.recorder?.stopAndExport()
            recordButton.setImage(UIImage(named: "icons8-circle-96"), for: .normal)
            isRecording = false
            let alert = UIAlertController(title: nil, message: "Saved to Photo Library", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadAnimations() {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "2.dae")!
        
        // This node will be parent of all the animation models
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Set up some properties
        node.position = SCNVector3(0, 0, -50)
        //node.scale = SCNVector3(1, 1, 1)
        
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
        
        print("animation loaded")
        print("==================")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}
