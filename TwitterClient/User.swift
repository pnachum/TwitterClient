//
//  User.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/16/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String!
    var screenName: String!
    var profileImageUrl: NSURL!
    var tagline: String?

    var dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as! String
        tagline = dictionary["description"] as? String
        profileImageUrl = NSURL(string: dictionary["profile_image_url_https"] as! String)
    }

    static let userDidLogoutNotification = "UserDidLogout"

    static var _currentUser: User?

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                } else {
                    return nil
                }
            }
            return _currentUser

        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}