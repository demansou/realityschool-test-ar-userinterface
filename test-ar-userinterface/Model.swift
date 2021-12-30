//
//  Model.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/9/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: String, CaseIterable {
    case furniture
    case decor
    case toys
    case electronics
    case cars
    case animals
    
    var label: String {
        get {
            switch self {
            case .furniture:
                return "Furniture"
            case .decor:
                return "Decor"
            case .toys:
                return "Toys"
            case .electronics:
                return "Electronics"
            case .cars:
                return "Cars"
            case .animals:
                return "Animals"
            }
        }
    }
}

class Model: ObservableObject, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var category: ModelCategory
    @Published var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation

        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "thumbnails/\(self.name).png") { localUrl in
            do {
                let imageData = try Data(contentsOf: localUrl)
                self.thumbnail = UIImage(data: imageData) ?? self.thumbnail
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }

    func asyncLoadModelEntity(handler: @escaping (_ completed: Bool, _ error: Error?) -> Void) {
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(self.name).usdz") { localUrl in
            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl)
                .sink(receiveCompletion: { loadCompletion in
                    switch loadCompletion {
                    case .failure(let error): print("Unable to load modelEntity for \(self.name). Error: \(error.localizedDescription)")
                        handler(false, error)
                    case .finished:
                        break;
                    }
                }, receiveValue: { modelEntity in
                    self.modelEntity = modelEntity
                    self.modelEntity?.scale *= self.scaleCompensation

                    handler(true, nil)

                    print("modelEntity for \(self.name) has been loaded.")
                })
        }
    }
}
