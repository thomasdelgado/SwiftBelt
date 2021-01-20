//
//  File.swift
//  
//
//  Created by Thomas Delgado on 19/01/21.
//

import Foundation

public extension UserDefaults {
    func saveObject<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }

    func codableObject<T: Codable>(forKey key: String) -> T? {
        if let savedObject = self.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(T.self, from: savedObject) {
                return object
            }
        }
        return nil
    }

    func saveObjects<T: Codable>(_ objects: [T], forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(objects) {
            self.set(encoded, forKey: key)
        }
    }

    func codableObjects<T: Codable>(forKey key: String) -> [T] {
        if let savedObject = self.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let objects = try? decoder.decode([T].self, from: savedObject) {
                return objects
            }
        }
        return []
    }
}
