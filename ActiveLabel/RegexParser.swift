//
//  RegexParser.swift
//  ActiveLabel
//
//  Created by Pol Quintana on 06/01/16.
//  Copyright © 2016 Optonaut. All rights reserved.
//

import Foundation

struct RegexParser {
    
    static let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" +
    "((https?://|www.|pic.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" +
    "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"
    
    static let urlDetector = try? NSRegularExpression(pattern: urlPattern, options: [.CaseInsensitive])
    static let phoneDetector = try? NSDataDetector(types: NSTextCheckingType.PhoneNumber.rawValue)
    
    static func getURLs(fromText text: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let urlDetector = urlDetector else { return [] }
        return urlDetector.matchesInString(text, options: [], range: range)
    }
    
    static func getPhoneNumbers(fromText text: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let phoneDetector = phoneDetector else { return [] }
        return phoneDetector.matchesInString(text, options: [], range: range)
    }
    
}