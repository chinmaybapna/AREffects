//
//  AeroplaneAnimationViewController.swift
//  AREffects
//
//  Created by Chinmay Bapna on 06/07/20.
//  Copyright © 2020 Chinmay Bapna. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision
import ARVideoKit

class AeroplaneAnimationViewController: UIViewController, ARSCNViewDelegate {
    
    var recorder : RecordAR?
    var rearCamera = true
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var recogniseLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    var isRecording = false
    
    @IBOutlet weak var sceneView: ARSCNView?
    
    var animations = [String: CAAnimation]()
    //var idle:Bool = true
    
    var planeExists: Bool = false
    
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    var visionRequests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        okButton.layer.cornerRadius = 10
        
        // Set the view's delegate
        sceneView!.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView!.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView!.scene = scene
        
        recorder = RecordAR(ARSceneKit: sceneView!)
        
        // Set up ML to recognise palm
        setupML()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        okButton.isHidden = true
        instructionLabel.isHidden = true
    }
    
    @IBAction func rotateCamera(_ sender: Any) {
        if(rearCamera) {
            let configuration = ARFaceTrackingConfiguration()
            sceneView!.session.run(configuration)
            rearCamera = false
        } else {
            let configuration = ARWorldTrackingConfiguration()
            sceneView!.session.run(configuration)
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
    
    func loadAnimations () {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "art.scnassets/plane/aeroplane2.dae")!
        
        // This node will be parent of all the animation models
        let node = SCNNode()
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Set up some properties
        node.position = SCNVector3(0, 0, -20)
        node.scale = SCNVector3(1, 1, 1)
        
        // Add the node to the scene
        sceneView!.scene.rootNode.addChildNode(node)
        
        print("animation loaded")
        print("==================")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.userFaceTrackingEnabled = true
        
        // Run the view's session
        sceneView!.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
        // Pause the view's session
        sceneView?.session.pause()
        sceneView?.removeFromSuperview()
        sceneView = nil
        recorder?.rest()
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
    
    // MARK: - MACHINE LEARNING
    
    private func setupML() {
        guard let selectedModel = try? VNCoreMLModel(for: example_5s0_hand_model().model) else {
            fatalError("Could not load the model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
    }
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        dispatchQueueML.async {
            // 1. Run Update.
                self.updateCoreML()
            // 2. Loop this function.
                self.loopCoreMLUpdate()
        }
    }
    
    func updateCoreML() {
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (sceneView?.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // Run Vision Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let classifications = observations[0...2] // top 3 results
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:" : %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        // Render Classifications
        DispatchQueue.main.async {
            let topPrediction = classifications.components(separatedBy: "\n")[0]
            let topPredictionName = topPrediction.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespaces)
            
            // Only use a prediction if confidence is above 80%
            let topPredictionScore:Float? = Float(topPrediction.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces))
            if (topPredictionScore != nil && topPredictionScore! > 0.9) {
                if (topPredictionName == "FIVE-UB-RHand" && !self.planeExists) {
                    self.recogniseLabel.text = "palm recognised"
                    print("===================")
                    print("palm recognised")
                    
                    self.planeExists = true
                    //Load the animation
                    self.loadAnimations()
                }
            }
        }
    }
}
