//
//  SolarSystemVc.swift
//  AmanRealityKitDemo
//
//  Created by Aman Joshi on 23/02/23.
//

import UIKit
import ARKit
import RealityKit

class SolarSystemVc: UIViewController {
    
    //----------------------------
    //MARK: IBOutlets
    @IBOutlet private weak var arView: ARView!
    @IBOutlet private weak var collView: UICollectionView!
    
    //----------------------------
    //MARK: Properties
    private var solarSystemScene = try! Experience.loadSolarSystem() //Load entities Synchronously
    private var arrDebugOptions: [DebugOptionModel] = [DebugOptionModel(name: AppKeys.DebugOptions.physics, option: .showPhysics),
                                                       DebugOptionModel(name: AppKeys.DebugOptions.statistics, option: .showStatistics),
                                                       DebugOptionModel(name: AppKeys.DebugOptions.anchorOrigins, option: .showAnchorOrigins),
                                                       DebugOptionModel(name: AppKeys.DebugOptions.anchorGeometry, option: .showAnchorGeometry),
                                                       DebugOptionModel(name: AppKeys.DebugOptions.worldOrigin, option: .showWorldOrigin),
                                                       DebugOptionModel(name: AppKeys.DebugOptions.featurePoints, option: .showFeaturePoints),
                                                       DebugOptionModel(name: AppKeys.DebugOptions.sceneUnderstanding, option: .showSceneUnderstanding),
                                                       DebugOptionModel(name: AppKeys.DebugOptions.none, option: .none)]
    
    //----------------------------
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    deinit {
        debugPrint("Deallocated ~> \(classForCoder.self)")
    }
}

//MARK: UI & Utility Methods
extension SolarSystemVc {
    
    private func setup() { //Load entities Synchronously
        setCoachingOverlay()
        arView.scene.anchors.append(solarSystemScene)
        debugOption(should: .showFeaturePoints)
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
    
    private func debugOption(should show: ARView.DebugOptions) {
        arView.debugOptions = show
    }
}

//MARK: IBAction
extension SolarSystemVc {
     
    @IBAction private func btnAnimateTap() {
        solarSystemScene.notifications.allNotifications.forEach({$0.post()})
    }
}

//MARK: ARCoachingOverlayView Delegate
extension SolarSystemVc: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        debugOption(should: .showFeaturePoints)
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        AlertManager.showAlert(msg: AppMessages.tapBehaviour, in: self.view)
        debugOption(should: .none)
    }
}

//MARK: UICollectionView Delegate & DataSource
extension SolarSystemVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrDebugOptions.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collView.dequeueReusableCell(withReuseIdentifier: DebugOptionCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? DebugOptionCell)?.setUI(option: arrDebugOptions[indexPath.row].name, shouldSelect: arView.debugOptions == arrDebugOptions[indexPath.row].option)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugOption(should: arrDebugOptions[indexPath.row].option)
        collView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: arrDebugOptions[indexPath.row].name.WidthWithNoConstrainedHeight(font: UIFont.systemFont(ofSize: 15.0, weight: .heavy)) + 20.0, height: 35.0)
    }
}
