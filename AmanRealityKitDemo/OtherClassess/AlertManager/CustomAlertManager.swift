//
//  CustomAlertManager.swift
//  AmanRealityKitDemo
//
//  Created by Aman Joshi on 16/02/23.
//

import Foundation
import UIKit

struct AlertManager {
    
    static func showAlert(title: String? = Constant._NULL_STRING_, msg: String, in view: UIView, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: msg, message: title, preferredStyle: .alert)
        view.window?.rootViewController?.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            view.window?.rootViewController?.dismiss(animated: true)
            if let _ = completion {
                completion!()
            }
        }
    }
}
