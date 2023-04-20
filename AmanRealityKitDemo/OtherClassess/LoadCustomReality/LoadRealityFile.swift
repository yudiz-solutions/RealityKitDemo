//
//  LoadRealityFile.swift
//  AmanRealityKitDemo
//
//  Created by Aman Joshi on 16/02/23.
//

import Foundation
import CoreText
import RealityKit
import Combine

///Load reality file from root directory
struct CustomRealityFile {
    
   private static func createRealityUrl(fileName: String, fileExtension: String, sceneName: String) -> URL? {
        guard let realityFileUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else { return nil }
        return realityFileUrl.appendingPathComponent(sceneName, isDirectory: false)
    }
    
    ///Asynchronous loading entites from root directory
   static func loadRealityComposerAsync(fileName: String, fileExtension: String, sceneName: String, completion: @escaping(Result<(Entity & HasAnchoring)?, Error>) -> Void) {
        guard let realityFileSceneUrl = createRealityUrl(fileName: fileName, fileExtension: fileExtension, sceneName: sceneName) else { return }
        
       let _ = Entity.loadAnchorAsync(contentsOf: realityFileSceneUrl).sink { loadCompletion in
            switch loadCompletion {
                case .finished: break
                case .failure(let error): completion(.failure(error))
            }
        } receiveValue: { anchorEntity in
            completion(.success(anchorEntity))
        }
    }
}
