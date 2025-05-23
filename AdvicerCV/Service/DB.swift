//
//  DB.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation

class AppData:ObservableObject {
    private let dbkey = "db2"
    @Published var db:DataBase = .init() {
        didSet {
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
    var coduments:[Document] = []
    struct Document: Codable {
        var data:Data?
        var url:URL?
        var request:PromtOpenAI? = nil
    }
}

extension [DataBase.Document] {
    mutating func update(_ newValue:DataBase.Document) {
        var found = false
        for i in 0..<self.count {
            if !found && self[i].url?.absoluteString == newValue.url?.absoluteString {
                found = true
                self[i] = newValue
                return
            }
        }
        if !found {
            self.append(newValue)
        }
    }
}
