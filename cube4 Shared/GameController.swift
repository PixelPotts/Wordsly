
//
//  GameController.swift
//  cube4 Shared
//
//  Created by Bryan Potts on 12/30/22.
//

import SceneKit

#if os(macOS)
typealias SCNColor = NSColor
#else
typealias SCNColor = UIColor
#endif


class GameController: NSObject, SCNSceneRendererDelegate {
    
    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    var swipeGesture: UISwipeGestureRecognizer!
    var swipeAnimationPlaying: Bool = false
    
    // Handle Swipe
    func handleSwipe(direction: String, location: (x:Float,y:Float)) {
        if(!swipeAnimationPlaying){
            print("Swipe detected!")
            print(direction, location)
            
            let location = CGPoint(x: Double(location.x), y: Double(location.y))
            let hitResults = sceneRenderer.hitTest(location, options: nil)
            
            if let hit = hitResults.first {
                if let _ = hit.node.geometry {
                    if(hit.node.name == "cube"){
                        swipeAnimationPlaying = true;
                        print(hit.node.name ?? "ERROR: UNKNOWN CUBE NODE")
                        let rotateUp = SCNAction.rotateBy(
                            x: direction == "up" ? .pi/2 : -.pi/2, y: 0, z: 0, duration: 0.25)
                        let completionHandler = SCNAction.run { (node) in
                            print("Animation completed!")
                            self.swipeAnimationPlaying = false;
                        }
                        let sequence = SCNAction.sequence([rotateUp, completionHandler])
                        hit.node.runAction(sequence)
                    }
                    print("Swipe gesture did not start on a cube.")
                }
            }
        }
    }
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene(named: "Art.scnassets/ship.scn")!
        super.init()
        sceneRenderer.delegate = self
        
        
        // MARK: CUBE CODE
        struct Cube {
            let node: SCNNode
            let width: CGFloat
            let height: CGFloat
            let length: CGFloat
            let chamferRadius: CGFloat
        }
        
        let spacing: CGFloat = 1.2
        let halfSpacing = spacing / 2.0
        let startX: CGFloat = -halfSpacing * 4.0
        let startY: CGFloat = halfSpacing * 4.0
        
        var cubes: [Cube] = []
        
        // Create an array of letters to be used for the faces of the cubes
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        for row in 0..<1 {
            for col in 0..<1 {
                let cubeNode = SCNNode(geometry: SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.13))
                for face in 0..<4 {
//                    let randomIndex = Int.random(in: 0..<letters.count)
                    let textGeometry = SCNText(string: "X", extrusionDepth: 0.1)
                    textGeometry.font = .systemFont(ofSize: 1)
                    textGeometry.firstMaterial?.diffuse.contents = UIColor.black
                    let paragraphStyle = NSMutableParagraphStyle(); paragraphStyle.alignment = .center
                    let textNode = SCNNode(geometry: textGeometry)
                    let (min, max) = cubeNode.boundingBox
                    let dx = min.x + 0.5 * (max.x - min.x)
                    let dy = min.y + 0.5 * (max.y - min.y)
                    let dz = min.z + 0.5 * (max.z - min.z)
                    var offset = (x: -0.37,y: -1.35, z: 0.5)
                    if(face == 0) {offset = (x: -0.37,y: -1.35, z: 0.5)} // FRONT
                    
                    if(face == 1) {
                        textNode.eulerAngles = SCNVector3(x: Float(-90) * 3.1459 / 180, y: 0 , z: 0) // TOP
                        offset = (x: -0.37,y: 0.5, z: 1.3)
                    }
                    if(face == 2) {
                        textNode.eulerAngles = SCNVector3(x: 0, y: Float(-180) * 3.1459 / 180 , z: Float(-180) * 3.1459 / 180) // ?
                        offset = (x: -0.3,y: 1.3, z: -0.5)
                    }
                    if(face == 3) {
                        textNode.eulerAngles = SCNVector3(x: Float(90) * 3.1459 / 180, y: 0 , z: 0) // TOP
                        offset = (x: -0.37,y: -0.5, z: -1.3)
                    }
                    
                    print(offset)
                    textNode.position = SCNVector3(
                        dx + cubeNode.position.x + Float(offset.x),
                        dy + cubeNode.position.y + Float(offset.y),
                        dz + cubeNode.position.z + Float(offset.z)
                    )
                    cubeNode.geometry?.firstMaterial?.transparency = 0.5
                    cubeNode.addChildNode(textNode)
                    
                }
                // Add the cube node to the scene
                let x = startX + CGFloat(col) * spacing
                let y = startY - CGFloat(row) * spacing
                cubeNode.position = SCNVector3(x: Float(x), y: Float(y), z: Float())
                cubeNode.name = "cube"
                
                scene.rootNode.addChildNode(cubeNode)
                
                // Create a cube object and add it to the cubes array
                let cube = Cube(node: cubeNode, width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
                cubes.append(cube)
            }
            
        }
        
        
        // MARK: CAMERA
        
        let cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 7
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 13)
        
        scene.rootNode.addChildNode(cameraNode)
        
        sceneRenderer.pointOfView = cameraNode
        
        sceneRenderer.scene = scene
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        // Called before each frame is rendered
        
    }
    
}
