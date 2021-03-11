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

public extension UIFont.TextStyle {
    func textStyle() -> Font.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .body: return .body
        case .callout: return .callout
        case .caption1: return .caption
        case .caption2: return .caption2
        case .footnote: return .footnote
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .title1: return .title
        case .title2: return .title2
        case .title3: return .title3
        default:
            return .body
        }
    }
}

public extension Font.TextStyle {
    func textStyle() -> UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .body: return .body
        case .callout: return .callout
        case .caption: return .caption1
        case .caption2: return .caption2
        case .footnote: return .footnote
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        default:
            return .body
        }
    }
}
