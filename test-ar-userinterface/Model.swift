//
//  Model.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/9/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
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
                return "Tables"
            case .decor:
                return "Decor"
            case .toys:
                return "Toy"
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

class Model {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    func asyncLoadModelEntity() {
        let fileName = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error): print("Unable to load modelEntity for \(fileName). Error: \(error.localizedDescription)")
                case .finished:
                    break;
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelEntity for \(self.name) has been loaded.")
            })
    }
}

struct Models {
    var all: [Model] = []
    private let defaultScaleCompensation: Float = 0.32/100
    
    init() {
        // Furniture
        let chairSwan = Model(name: "chair_swan", category: .furniture)
        
        self.all += [chairSwan]
                
        // Decor
        let cupSaucerSet = Model(name: "cup_saucer_set", category: .decor)
        let flowerTulip = Model(name: "flower_tulip", category: .decor)
        let gramophone = Model(name: "gramophone", category: .decor, scaleCompensation: 0.25)
        let teaPot = Model(name: "teapot", category: .decor)
        let wateringCan = Model(name: "wateringcan", category: .decor)
        
        self.all += [cupSaucerSet, flowerTulip, gramophone, teaPot, wateringCan]
        
        // Toys
        let toyBiplane = Model(name: "toy_biplane", category: .toys)
        let toyCar = Model(name: "toy_car", category: .toys)
        let toyDrummer = Model(name: "toy_drummer", category: .toys)
        let toyRobotVintage = Model(name: "toy_robot_vintage", category: .toys)
        
        self.all += [toyBiplane, toyCar, toyDrummer, toyRobotVintage]
        
        // Electronics
        let fenderStratocaster = Model(name: "fender_stratocaster", category: .electronics)
        let tvRetro = Model(name: "tv_retro", category: .electronics)
        
        self.all += [fenderStratocaster, tvRetro]
        
        // Cars
        let datsun = Model(name: "1972_Datsun_240k_GT", category: .cars, scaleCompensation: 0.1)
        let porsche = Model(name: "1975_Porsche_911_930_Turbo", category: .cars, scaleCompensation: 0.1)
        
        self.all += [datsun, porsche]
        
        // Animals
        let chook = Model(name: "Chook", category: .animals, scaleCompensation: 0.25)
        
        self.all += [chook]
    }
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter( {$0.category == category})
    }
}
