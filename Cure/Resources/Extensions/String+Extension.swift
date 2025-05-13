//
//  String+Extension.swift
//  Cure
//
//  Created by MacBook Air MII  on 13/5/25.
//

import Foundation

extension String {
    func matchRegex(pattern: Regex) -> Bool {
        let range: NSRange = NSMakeRange(0, countElements(self))
        if pattern.regex != nil {
            let matches: [AnyObject] = pattern.regex!.matches(in: self, options: pattern.matchingOptions, range: range)
            return matches.count > 0
        }
        return false
    }
    
    
    func match(patternString: String) -> Bool {
        return self.matchRegex(pattern: Regex(pattern: patternString))
    }
    
    
    func replaceRegex(pattern: Regex, template: String) -> String {
        if self.matchRegex(pattern: pattern) {
            let range: NSRange = NSMakeRange(0, countElements(self))
            if pattern.regex != nil {
                return pattern.regex!.stringByReplacingMatches(in: self, options: pattern.matchingOptions, range: range, withTemplate: template)
            }
        }
        return self
    }
    
    
    func countElements(_ string: String) -> Int {
        return string.utf16.count
    }
    
    
    func replace(pattern: String, template: String) -> String {
        return self.replaceRegex(pattern: Regex(pattern: pattern), template: template)
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return self.match(patternString: emailRegex)
    }
    
    
    var isValidPassword: Bool {
        let passwordRegex = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}"
        return self.match(patternString: passwordRegex)
    }
    
    
    var isValidGithubUsername: Bool {
        // Explanation:
        // ^              : Start of string
        // (?!-)          : Assert that the string does not start with a hyphen
        // (?!.*--)       : Assert that there are no consecutive hyphens in the string
        // [A-Za-z0-9-]   : Allowed characters (alphanumeric or hyphen)
        // {3,39}         : Length between 3 and 39 characters
        // (?<!-)         : Assert that the string does not end with a hyphen
        // $              : End of string
        let githubUsernameRegex = "^(?!-)(?!.*--)[A-Za-z0-9-]{3,39}(?<!-)$"
        return self.match(patternString: githubUsernameRegex)
    }
}

// MARK: Implementation Hint

/// EMAIL VALIDATION
/*
 guard let emailText = usernameTextField.text, !emailText.isEmpty else {
 print("No email entered")
 return
 }
 
 if emailText.isValidEmail {
 let followerListVC = FollowerListVC()
 followerListVC.username = emailText
 followerListVC.title = emailText
 navigationController?.pushViewController(followerListVC, animated: true)
 } else {
 print("Invalid email format")
 }
 */
