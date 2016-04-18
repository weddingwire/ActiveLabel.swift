//
//  ActiveType.swift
//  ActiveLabel
//
//  Created by Johannes Schickling on 9/4/15.
//  Copyright © 2015 Optonaut. All rights reserved.
//

import Foundation

enum ActiveElement {
    case URL(String)
    case Phone(String)
    case None
}

public enum ActiveType {
    case URL
    case Phone
    case None
}

struct ActiveBuilder {
    
    static func createURLElements(fromText text: String, range: NSRange) -> [(range: NSRange, element: ActiveElement)] {
        let urls = RegexParser.getURLs(fromText: text, range: range)
        let nsstring = text as NSString
        var elements: [(range: NSRange, element: ActiveElement)] = []
        
        for url in urls where url.range.length > 2 {
            let word = nsstring.substringWithRange(url.range)
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let element = ActiveElement.URL(word)
            elements.append((url.range, element))
        }
        return elements
    }
    
    static func createPhoneNumberElements(fromText text: String, range: NSRange) -> [(range: NSRange, element: ActiveElement)] {
        let urls = RegexParser.getPhoneNumbers(fromText: text, range: range)
        let nsstring = text as NSString
        var elements: [(range: NSRange, element: ActiveElement)] = []
        
        for url in urls where url.range.length > 2 {
            let word = nsstring.substringWithRange(url.range)
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let element = ActiveElement.Phone(word)
            elements.append((url.range, element))
        }
        return elements
    }
}
