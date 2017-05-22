//
//  ActiveTypeTests.swift
//  ActiveTypeTests
//
//  Created by Johannes Schickling on 9/4/15.
//  Copyright © 2015 Optonaut. All rights reserved.
//

import XCTest
@testable import ActiveLabel

extension ActiveElement: Equatable {}

public func ==(a: ActiveElement, b: ActiveElement) -> Bool {
    switch (a, b) {
    case (.url(let a), .url(let b)) where a == b: return true
    case (.none, .none): return true
    default: return false
    }
}

class ActiveTypeTests: XCTestCase {
    
    let label = ActiveLabel
    
    var activeElements: [ActiveElement] {
        return label.activeElements.flatMap({$0.1.flatMap({$0.element})})
    }
    
    var currentElementString: String? {
        guard let currentElement = activeElements.first else { return nil }
        switch currentElement {
        case .url(let url):
            return url
        case .phone(let number):
            return number
        case .none:
            return ""
        }
    }
    
    var currentElementType: ActiveType? {
        guard let currentElement = activeElements.first else { return nil }
        switch currentElement {
        case .url:
            return .url
        case .phone:
            return .phone
        case .none:
            return .none
        }
    }
    
    override func setUp() {
        super.setUp()
        label.enabledTypes = [.mention, .hashtag, .url]
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInvalid() {
        label.text = ""
        XCTAssertEqual(activeElements.count, 0)
        label.text = " "
        XCTAssertEqual(activeElements.count, 0)
        label.text = "x"
        XCTAssertEqual(activeElements.count, 0)
        label.text = "ಠ_ಠ"
        XCTAssertEqual(activeElements.count, 0)
        label.text = "😁"
        XCTAssertEqual(activeElements.count, 0)
    }
    
    func testURL() {
        label.text = "http://www.google.com"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "http://www.google.com")
        XCTAssertEqual(currentElementType, ActiveType.url)

        label.text = "https://www.google.com"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "https://www.google.com")
        XCTAssertEqual(currentElementType, ActiveType.url)

        label.text = "http://www.google.com."
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "http://www.google.com")
        XCTAssertEqual(currentElementType, ActiveType.url)

        label.text = "www.google.com"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "www.google.com")
        XCTAssertEqual(currentElementType, ActiveType.url)
        
        label.text = "pic.twitter.com/YUGdEbUx"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "pic.twitter.com/YUGdEbUx")
        XCTAssertEqual(currentElementType, ActiveType.url)

        label.text = "google.com"
        XCTAssertEqual(activeElements.count, 0)
    }
    
    func testPhoneNumbers() {
        label.text = "1-800-555-5555"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementType, ActiveType.phone)
        
        label.text = "301.987.6543"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementType, ActiveType.phone)
        
        label.text = "1-800-COMCAST"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementType, ActiveType.phone)
        
        label.text = "+1-(800)-555-2468"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementType, ActiveType.phone)

        label.text = "8473292"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementType, ActiveType.phone)
    }

    
    // test for issue https://github.com/optonaut/ActiveLabel.swift/issues/64
    func testIssue64pic() {
        label.text = "picfoo"
        XCTAssertEqual(activeElements.count, 0)
    }
    
    // test for issue https://github.com/optonaut/ActiveLabel.swift/issues/64
    func testIssue64www() {
        label.text = "wwwbar"
        XCTAssertEqual(activeElements.count, 0)
    }

    func testOnlyMentionsEnabled() {
        label.enabledTypes = [.mention]

        label.text = "@user #hashtag"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "user")
        XCTAssertEqual(currentElementType, ActiveType.mention)

        label.text = "http://www.google.com"
        XCTAssertEqual(activeElements.count, 0)

        label.text = "#somehashtag"
        XCTAssertEqual(activeElements.count, 0)

        label.text = "@userNumberOne #hashtag http://www.google.com @anotheruser"
        XCTAssertEqual(activeElements.count, 2)
        XCTAssertEqual(currentElementString, "userNumberOne")
        XCTAssertEqual(currentElementType, ActiveType.mention)
    }

    func testOnlyHashtagEnabled() {
        label.enabledTypes = [.hashtag]

        label.text = "@user #hashtag"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "hashtag")
        XCTAssertEqual(currentElementType, ActiveType.hashtag)

        label.text = "http://www.google.com"
        XCTAssertEqual(activeElements.count, 0)

        label.text = "@someuser"
        XCTAssertEqual(activeElements.count, 0)

        label.text = "#hashtagNumberOne #hashtag http://www.google.com @anotheruser"
        XCTAssertEqual(activeElements.count, 2)
        XCTAssertEqual(currentElementString, "hashtagNumberOne")
        XCTAssertEqual(currentElementType, ActiveType.hashtag)
    }

    func testOnlyURLsEnabled() {
        label.enabledTypes = [.url]

        label.text = "http://www.google.com #hello"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "http://www.google.com")
        XCTAssertEqual(currentElementType, ActiveType.url)

        label.text = "@user"
        XCTAssertEqual(activeElements.count, 0)

        label.text = "#somehashtag"
        XCTAssertEqual(activeElements.count, 0)

        label.text = " http://www.apple.com @userNumberOne #hashtag http://www.google.com @anotheruser"
        XCTAssertEqual(activeElements.count, 2)
        XCTAssertEqual(currentElementString, "http://www.apple.com")
        XCTAssertEqual(currentElementType, ActiveType.url)
    }

    func testOnlyCustomEnabled() {
        let newType = ActiveType.custom(pattern: "\\sare\\b")
        label.enabledTypes = [newType]

        label.text = "http://www.google.com  are #hello"
        XCTAssertEqual(activeElements.count, 1)
        XCTAssertEqual(currentElementString, "are")
        XCTAssertEqual(currentElementType, customEmptyType)

        label.text = "@user"
        XCTAssertEqual(activeElements.count, 0)

        label.text = "#somehashtag"
        XCTAssertEqual(activeElements.count, 0)

        label.text = " http://www.apple.com are @userNumberOne #hashtag http://www.google.com are @anotheruser"
        XCTAssertEqual(activeElements.count, 2)
        XCTAssertEqual(currentElementString, "are")
        XCTAssertEqual(currentElementType, customEmptyType)
    }

    func testStringTrimming() {
        let text = "Tweet with long url: https://twitter.com/twicket_app/status/649678392372121601 and short url: https://hello.co"
        label.urlMaximumLength = 30
        label.text = text

        XCTAssertNotEqual(text.characters.count, label.text!.characters.count)
    }

    func testStringTrimmingURLShorterThanLimit() {
        let text = "Tweet with short url: https://hello.co"
        label.urlMaximumLength = 30
        label.text = text

        XCTAssertEqual(text, label.text!)
    }

    func testStringTrimmingURLLongerThanLimit() {
        let trimLimit = 30
        let url = "https://twitter.com/twicket_app/status/649678392372121601"
        let trimmedURL = url.trim(to: trimLimit)
        let text = "Tweet with long url: \(url)"
        label.urlMaximumLength = trimLimit
        label.text = text


        XCTAssertNotEqual(text.characters.count, label.text!.characters.count)

        switch activeElements.first! {
        case .url(let original, let trimmed):
            XCTAssertEqual(original, url)
            XCTAssertEqual(trimmed, trimmedURL)
        default:
            XCTAssert(false)
        }

    }
}
