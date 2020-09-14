//
//  SpectaclesFilterViewController.swift
//  AREffects
//
//  Created by Chinmay Bapna on 23/07/20.
//  Copyright © 2020 Chinmay Bapna. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SpectaclesFilterViewController: UIViewController, ARSCNViewDelegate {

    private let planeWidthForNecklace : CGFloat = 0.38
    private let planeHeightForNecklace : CGFloat = 0.4
    private let nodeYPositionForNecklace : Float = -0.18
    
    private let planeWidthForglasses : CGFloat = 0.225
    private let planeHeightForglasses : CGFloat = 0.225
    private let nodeYPositionForglasses : Float = 0.0275
    
    private let planeWidthForLeftEarring : CGFloat = 0.2
    private let planeHeightForLeftEarring : CGFloat = 0.2
    private let nodeYPositionForLeftEarring : Float = -0.039
    private let nodeXPositionForLeftEarring : Float = -0.076
    
    private let planeWidthForRightEarring : CGFloat = 0.2
    private let planeHeightForRightEarring : CGFloat = 0.2
    private let nodeYPositionForRightEarring : Float = -0.039
    private let nodeXPositionForRightEarring : Float = 0.087
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        
        let glassesPlane = SCNPlane(width: planeWidthForglasses, height: planeHeightForglasses)
        //let glassesPlane = SCNPlane(width: 1, height: 1)
        glassesPlane.firstMaterial?.isDoubleSided = true
        glassesPlane.firstMaterial?.diffuse.contents = UIColor.red
        
        let glassesNode = SCNNode()
        glassesNode.geometry = glassesPlane
        glassesNode.position.z = faceNode.boundingBox.max.z * 3/4
        glassesNode.position.y = nodeYPositionForglasses
        
        faceNode.addChildNode(glassesNode)
        
        glassesPlane.firstMaterial?.diffuse.contents = UIImage(named: "goggles-4")
        
        //necklace
        let necklacePlane = SCNPlane(width: planeWidthForNecklace, height: planeHeightForNecklace)
        //let glassesPlane = SCNPlane(width: 1, height: 1)
        necklacePlane.firstMaterial?.isDoubleSided = false
        necklacePlane.firstMaterial?.diffuse.contents = UIColor.red
        
        let necklaceNode = SCNNode()
        necklaceNode.geometry = necklacePlane
        necklaceNode.position.z = -1 * faceNode.boundingBox.max.z * 1/4
        necklaceNode.position.y = nodeYPositionForNecklace
        
        faceNode.addChildNode(necklaceNode)
        
        necklacePlane.firstMaterial?.diffuse.contents = UIImage(named: "jewellery-1")
        
        //left earring
        let leftEarringPlane = SCNPlane(width: planeWidthForLeftEarring, height: planeHeightForLeftEarring)
        //let glassesPlane = SCNPlane(width: 1, height: 1)
        leftEarringPlane.firstMaterial?.isDoubleSided = true
        leftEarringPlane.firstMaterial?.diffuse.contents = UIColor.red
        
        let leftEarringNode = SCNNode()
        leftEarringNode.geometry = leftEarringPlane
        leftEarringNode.position.x = nodeXPositionForLeftEarring
        leftEarringNode.position.z = -1 * faceNode.boundingBox.max.z * 3/4
        leftEarringNode.position.y = nodeYPositionForLeftEarring
        
        faceNode.addChildNode(leftEarringNode)
        
        leftEarringPlane.firstMaterial?.diffuse.contents = UIImage(named: "jewellery-2")
        
        //right earring
        let rightEarringPlane = SCNPlane(width: planeWidthForRightEarring, height: planeHeightForRightEarring)
        //let glassesPlane = SCNPlane(width: 1, height: 1)
        rightEarringPlane.firstMaterial?.isDoubleSided = true
        rightEarringPlane.firstMaterial?.diffuse.contents = UIColor.red
        
        let rightEarringNode = SCNNode()
        rightEarringNode.geometry = rightEarringPlane
        rightEarringNode.position.x = nodeXPositionForRightEarring
        rightEarringNode.position.z = -1 * faceNode.boundingBox.max.z * 3/4
        rightEarringNode.position.y = nodeYPositionForLeftEarring
        
        faceNode.addChildNode(rightEarringNode)
        
        rightEarringPlane.firstMaterial?.diffuse.contents = UIImage(named: "jewellery-3")
        
        faceNode.geometry?.firstMaterial?.transparency = 0
        
        return faceNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
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
