//
//  Regex.swift.swift
//  Cure
//
//  Created by MacBook Air MII  on 13/5/25.
//


import Foundation

struct Regex {
    var pattern: String {
        didSet {
            updateRegex()
        }
    }
    var expressionOptions: NSRegularExpression.Options {
        didSet {
            updateRegex()
        }
    }
    var matchingOptions: NSRegularExpression.MatchingOptions

    var regex: NSRegularExpression?

    init(pattern: String, expressionOptions: NSRegularExpression.Options, matchingOptions: NSRegularExpression.MatchingOptions) {
        self.pattern = pattern
        self.expressionOptions = expressionOptions
        self.matchingOptions = matchingOptions
        updateRegex()
    }

    init(pattern: String) {
        self.pattern = pattern
        expressionOptions = NSRegularExpression.Options(rawValue: 0)
        matchingOptions = NSRegularExpression.MatchingOptions(rawValue: 0)
        updateRegex()
    }

    mutating func updateRegex() {
        do {
            regex = try NSRegularExpression(pattern: pattern, options: expressionOptions)
        } catch {
            print("Failed to create regex: \(error)")
        }
    }
}

