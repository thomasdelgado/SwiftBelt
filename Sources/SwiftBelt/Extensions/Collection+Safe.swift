//
//  File.swift
//  
//
//  Created by Thomas Delgado on 15/03/21.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
