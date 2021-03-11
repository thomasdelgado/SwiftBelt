//
//  File.swift
//  
//
//  Created by Thomas Delgado on 10/03/21.
//

import UIKit
import SwiftUI

public extension UIFont.Weight {
    func fontWeight() -> Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .light: return .light
        case .thin: return .thin
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default:
            return .regular
        }
    }
}

