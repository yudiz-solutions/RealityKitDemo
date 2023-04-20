//
//  WelcomeVc.swift
//  AmanRealityKitDemo
//
//  Created by Aman Joshi on 23/02/23.
//

import UIKit

class WelcomeVc: UIViewController {
    
    //----------------------------
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: UI & Utility Methods
extension WelcomeVc { }

//MARK: IBAction
extension WelcomeVc {
    
    @IBAction private func btnSolarSystemTap() {
        AlertManager.showAlert(msg: AppMessages.planeDetection, in: view) { [weak self] in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: SolarSystemVc.identifier, sender: nil)
//            if let solarVc = self.storyboard?.instantiateViewController(withIdentifier: SolarSystemVc.identifier()) {
//                self.navigationController?.pushViewController(solarVc, animated: true)
//            }
        }
    }
    
    @IBAction private func btnTransportTap() {
        AlertManager.showAlert(msg: AppMessages.airplaneBehaviour, in: view) { [weak self] in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: TestObjectVc.identifier, sender: nil)
//            if let testObjectVc = self.storyboard?.instantiateViewController(withIdentifier: TestObjectVc.identifier()) {
//                self.navigationController?.pushViewController(testObjectVc, animated: true)
//            }
        }
    }
}
