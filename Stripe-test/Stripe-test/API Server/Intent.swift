//
//  Intent.swift
//  Stripe-test
//
//  Created by Constantine Likhachov on 10/8/19.
//  Copyright © 2019 Constantine Likhachov. All rights reserved.
//

import Foundation

class Intent: NSObject {
    
    var client_secret: String?
    
    //MARK: Parsing
    
    init(withDictionary dictionary: Dictionary<String, AnyObject>) {
        
        if let client_secret = dictionary["client_secret"] as? String {
            self.client_secret = client_secret
        }
        super.init()
    }
    
    override init() {
        super.init()
    }
}
