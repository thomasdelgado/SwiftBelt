//
//  Data+Serialization.swift
//  
//
//  Created by Thomas Delgado on 24/02/21.
//

import Foundation

public extension Data {
    func toJSON() throws -> Dictionary<String, Any> {
        let result = try JSONSerialization.jsonObject(with: self, options: [])
        if let result = result as? Dictionary<String, Any> {
            return result
        } else {
            debugPrint("Failed to convert object to dictionary")
            debugPrint(result)
            return [:]
        }
    }
}
