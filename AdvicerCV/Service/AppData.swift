//
//  DB.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation

class AppData:ObservableObject {
    private let dbkey = "db7"
    @Published var deviceSize:CGSize = .zero
    static let adviceLimit:Int = 4
    @Published var db:DataBase = .init() {
        didSet {
            print("updatingdb")
            if dataLoaded {
                if Thread.isMainThread {
                    DispatchQueue(label: "db", qos: .userInitiated).async {
                        UserDefaults.standard.set(self.db.decode ?? .init(), forKey: self.dbkey)
                    }
                } else {
                    UserDefaults.standard.set(self.db.decode ?? .init(), forKey: dbkey)
                }
            } else {
                dataLoaded = true
            }
        }
    }
    
    init() {
        self.fetch()
    }
    
    private var dataLoaded = false
    
    func fetch() {
        if Thread.isMainThread {
            DispatchQueue(label: "db", qos: .userInitiated).async {
                self.performFetchDB()
            }
        }
        else {
            self.performFetchDB()
            
        }
    }
    
    private func performFetchDB() {
        let db = UserDefaults.standard.data(forKey: dbkey)
        DispatchQueue.main.async {
            self.dataLoaded = false
            self.db = .configure(db) ?? .init()
        }
    }
}

struct DataBase: Codable {
    var documents:[Document] = []
    var generatorContent:CVGenerator = .init()
    var cvContent:GeneratorPDFViewModel.CVContent = .mock
    struct CVGenerator:Codable {
        var content:GeneratorPDFViewModel.CVContent = .mock
        var apperance:GeneratorPDFViewModel.Appearence = .init()
        
    }
}

