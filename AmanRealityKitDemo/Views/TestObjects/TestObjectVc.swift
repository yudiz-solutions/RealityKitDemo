//
//  TestObjectVc.swift
//  AmanRealityKitDemo
//
//  Created by Aman Joshi on 23/02/23.
//

import UIKit
import ARKit
import RealityKit

fileprivate enum Rotation {
    case pitch(Pitch), roll(Roll), yaw(Yaw)
    
    enum Pitch { case up, down }
    
    enum Roll { case left, right }
    
    enum Yaw { case leftToRight, rightToLeft }
    
    var titleForBtn: String {
        switch self {
            case .pitch(_): return AppKeys.pitch
            case .roll(_): return AppKeys.roll
            case .yaw(_): return AppKeys.yaw
        }
    }
}

fileprivate enum Direction: Int {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
    case away = 4
    case close = 5
    
    case none = 100
    
    var shouldAdd: Bool {
        switch self {
            case .up, .right, .close: return true
            case .down, .left, .away, .none: return false
        }
    }
}

//MARK: TestObject ViewController
class TestObjectVc: UIViewController {
    //----------------------------
    //MARK: IBOutlet
    @IBOutlet private weak var arView: ARView!
    
    //----------------------------
    //MARK: Properties
    private let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.1, 0.1])
    private var myEntity: Entity?
    
    private var rotation: Rotation = .pitch(.up)
    
    //----------------------------
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadScene()
        setCoachingOverlay()
        setOcclusion()
    }
    
    deinit {
        debugPrint("Deallocated ~> \(classForCoder.self)")
    }
}

//MARK: UI & Utility Methods
extension TestObjectVc {
   
    private func loadScene() { //Loading entities asynchronously, completion handler provide loaded entities
        Experience.loadFreeWorldAsync { [weak self] result in
            guard let `self` = self else { return }
            switch result {
                 case .success(let entities):
                    self.myEntity = entities.airplane
                    self.myEntity?.generateCollisionShapes(recursive: true)
                    self.myEntity?.position = SIMD3.zero
                    self.anchor.addChild(self.myEntity!)
                    self.arView.scene.addAnchor(self.anchor)

                    guard let _ = self.myEntity as? HasCollision else { return }
                    self.arView.installGestures([.all], for: self.myEntity as! HasCollision)
                    
                case .failure(let error):
                    AlertManager.showAlert(msg: error.localizedDescription, in: self.view)
                    print("Error loading road scene: \(error)")
            }
        }
    }
    
    private func setCoachingOverlay() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.frame = view.bounds
        self.view.addSubview(coachingOverlay)

        coachingOverlay.delegate = self

        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = arView.session
    }
    
    private func setOcclusion() {
        let config = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            print("Supports scene depth")
            config.frameSemantics.insert(.sceneDepth)
        } else {
            print("This does not support scene depth")
        }
        config.planeDetection = .horizontal
        
        arView.session.run(config)
    }
    
    private func moveEntity(to direction: Direction) { //Move entity to specified direction
        if direction == .none { return }
        guard let myEntity = myEntity else { return }
        
        let distance: Float = 0.3 //in meters
        var transform = myEntity.transform
        transform.translation = SIMD3(x: (direction.shouldAdd ? myEntity.position.x + distance : myEntity.position.x - distance),
                                      y: (direction.shouldAdd ? myEntity.position.y + distance : myEntity.position.y - distance),
                                      z: (direction.shouldAdd ? myEntity.position.z + distance : myEntity.position.z - distance))
        myEntity.move(to: transform, relativeTo: myEntity.parent, duration: 2.0, timingFunction: .linear)
    }
    
    private func rotateEntity(in rotationAxis: Rotation) { //Rotate Entity on various axes [Pitch, Yaw, Roll]
        guard let myEntity = myEntity else { return }
        
        let angle: Float = 30.0
        var transform = myEntity.transform
        
        switch rotationAxis {
            case .pitch(let pitch):
                switch pitch {
                    case .up: transform.rotation = simd_quatf(angle: angle, axis: [1, 0, 0])
                    case .down: transform.rotation = simd_quatf(angle: -angle, axis: [1, 0, 0])
                }
                
            case .roll(let roll):
                switch roll {
                    case .left: transform.rotation = simd_quatf(angle: -angle, axis: [0, 0, 1])
                    case .right: transform.rotation = simd_quatf(angle: angle, axis: [0, 0, 1])
                }
                
            case .yaw(let yaw):
                switch yaw {
                    case .leftToRight: transform.rotation = simd_quatf(angle: angle, axis: [0, 1, 0])
                    case .rightToLeft: transform.rotation = simd_quatf(angle: -angle, axis: [0, 1, 0])
                }
        }
        
        myEntity.move(to: transform, relativeTo: myEntity.parent, duration: 0.4, timingFunction: .linear)
    }
}

//MARK: IBAction
extension TestObjectVc  {
    
    @IBAction private func btnResetPositionTap() { //Reset entity position to center coordinates [0, 0, 0]
        guard let myEntity = myEntity else { return }
        myEntity.move(to: Transform(scale: myEntity.transform.scale,
                                    rotation: simd_quatf(),
                                    translation: .zero),
                      relativeTo: myEntity.parent,
                      duration: 1.0,
                      timingFunction: .easeInOut)
    }
    
    @IBAction private func btnDirectionsTap(_ sender: UIButton) { //Array of direction buttons configured with tags
        moveEntity(to: Direction(rawValue: sender.tag) ?? .none)
    }
    
    @IBAction private func btnRotationAxisTap(_ sender: UIButton) { //Rotation axis: Pitch, Roll and Yaw
        let arrAxis: [Any] = [Rotation.pitch(.up), Rotation.roll(.right), Rotation.yaw(.rightToLeft)]
        
        sender.tag = sender.tag == 2 ? 0 : sender.tag + 1
        if arrAxis.count >= sender.tag {
            if let _ = arrAxis[sender.tag] as? Rotation {
                rotation = (arrAxis[sender.tag] as! Rotation)
                sender.setTitle(rotation.titleForBtn, for: .normal)
            }
        }
    }
    
    @IBAction private func btnRotateTap(_ sender: UIButton) { //0 is Left and 1 is Right [Tags]
        switch rotation {
            case .pitch(.up), .pitch(.down): rotateEntity(in: .pitch(sender.tag == 0 ? .up : .down))
                
            case .roll(.right), .roll(.left): rotateEntity(in: .roll(sender.tag == 0 ? .left : .right))
                
            case .yaw(.rightToLeft), .yaw(.leftToRight): rotateEntity(in: .yaw(sender.tag == 0 ? .leftToRight : .rightToLeft))
        }
    }
}

//MARK: ARCoachingOverlayView Delegate
extension TestObjectVc: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        arView.debugOptions = .showFeaturePoints
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        arView.debugOptions = .none
    }
}
