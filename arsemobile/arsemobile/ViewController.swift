//
//  ViewController.swift
//  arsemobile
//
//  Created by csuftitan on 3/9/23.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3D model
        let box = MeshResource.generateBox(size: 0.1)
        let material = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
        
        let boxEntity = ModelEntity(mesh: box, materials: [material])
        
        // Create Anchor (locks virtual object to point in real world)
        let boxAnchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z:0))
        boxAnchor.addChild(boxEntity)
        
        // Add anchor to scene
        arView.scene.addAnchor(boxAnchor)
    }
}
