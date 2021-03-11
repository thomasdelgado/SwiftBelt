//
//  File.swift
//  
//
//  Created by Thomas Delgado on 10/03/21.
//

import UIKit

public class CustomFontCatalog {
    static public var fonts: [UIFont.TextStyle: CustomFont] = [:]
}

public struct CustomFont {
    public var family: String?
    public var traits: [UIFontDescriptor.SymbolicTraits] = []
    public var weight: UIFont.Weight?
    public var size: CGFloat?

    public init(family: String? = nil,
         traits: [UIFontDescriptor.SymbolicTraits] = [],
         weight: UIFont.Weight? = nil,
         size: CGFloat? = nil) {
        self.family = family
        self.traits = traits
        self.weight = weight
        self.size = size
    }
}

public extension UIFont {
    static func customFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        let font = CustomFontCatalog.fonts[textStyle]
        return customFont(forTextStyle: textStyle,
                          withFamily: font?.family,
                          withTraits: font?.traits ?? [],
                          weight: font?.weight,
                          size: font?.size)
    }

    static func customFont(forTextStyle textStyle: UIFont.TextStyle,
                           withFamily family: String? = nil,
                           withTraits traits: [UIFontDescriptor.SymbolicTraits] = [],
                           weight: UIFont.Weight? = nil,
                           size: CGFloat? = nil) -> UIFont {
        var descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        //if family is set, we need to restart the descriptor
        if let family = family {
            descriptor = UIFont(name: family, size: descriptor.pointSize)?.fontDescriptor ?? descriptor
        }
        //apply traits
        traits.forEach {
            if let newDescriptor = descriptor.withSymbolicTraits($0) {
                descriptor = newDescriptor
            }
        }

        var font = UIFont(
            descriptor: descriptor,
            size: size ?? descriptor.pointSize
        )
        if let weight = weight {
            font = font.withWeight(weight)
        }

        //Create a dynamic scaled font size
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }

    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits) ?? fontDescriptor
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

    /// Returns a new font with the weight specified
    /// - Parameter weight: The new font weight
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]

        traits[.weight] = weight

        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName

        let descriptor = UIFontDescriptor(fontAttributes: attributes)

        return UIFont(descriptor: descriptor, size: pointSize)
    }

    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }

    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }
}
