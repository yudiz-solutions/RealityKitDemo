//
//  AppMessages.swift
//  AmanRealityKitDemo
//
//  Created by Yudiz Solutions Limited on 21/03/23.
//

import Foundation
import AVFAudio

struct AppKeys {
    
    static let pitch = "Pitch"
    static let roll = "Roll"
    static let yaw = "Yaw"
    
    struct DebugOptions {
        
          static let physics = "Physics"
          static let statistics = "Statistics"
          static let anchorOrigins = "Anchor Origins"
          static let anchorGeometry = "Anchor Geometry"
          static let worldOrigin = "World Origin"
          static let featurePoints = "Feature Points"
          static let sceneUnderstanding = "Scene Understanding"
          static let none = "None"
    }
}

struct AppMessages {
    
    static let planeDetection = "Object behaviour configured in RealityKit Composer, User can trigger behaviour using notification trigger"
    static let airplaneBehaviour = "Airplane behavior can be controlled manually using the controls provided"
    static let tapBehaviour = "MOVE AWAY FROM THE ANCHOR \n Tap animate button on top left corner once to trigger action sequences of the objects"
}
