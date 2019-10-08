//
//  ServerRequest.swift
//  Stripe-test
//
//  Created by Constantine Likhachov on 10/8/19.
//  Copyright © 2019 Constantine Likhachov. All rights reserved.
//

import Foundation
import Alamofire

class ServerRequest<T> : NSObject {
    
    let baseUrlIntentString =  "https://api.stripe.com/v1/setup_intents"
    
    var responseObject: T?
    
    var error: NSError?
    
    var responseMessage: String?
    
    var responseCodeError: Int?
    
    let sessionManager = Alamofire.SessionManager.default
    
    //MARK: - Interface -
    
    func cancel() {
        
    }
    
    func parseError(_ response: [String : AnyObject]) ->  String? {
        return response["message"] as? String
    }
    
    func headersWithStripeToken(_ token: String) -> HTTPHeaders {
        var headers = sessionManager.session.configuration.httpAdditionalHeaders as! HTTPHeaders
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }
    
    func hasAlertMessage() -> String? {
        var messageText: String?
        
        if error != nil || responseMessage != nil {
            if error != nil {
                messageText = NSLocalizedString(error?.localizedDescription ??  "", comment: "")
            } else if let text = responseMessage {
                messageText = text
            }
        }
        
        return messageText
    }
}
