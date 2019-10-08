//
//  PaymentRequest.swift
//  Stripe-test
//
//  Created by Constantine Likhachov on 10/8/19.
//  Copyright © 2019 Constantine Likhachov. All rights reserved.
//

import Alamofire
class PaymentRequest: ServerRequest<Intent> {
    
     let secretKey = "sk_test_qMcDDokl6uG9DDLpGLsOFzb400aPX2vaTH"

    func createSetupIntent(_ closure: @escaping (ServerRequest<Intent>) -> Void) {
        
        let payment_methodTypes = ["card"]
        
        let parameters = [
            "payment_method_types": payment_methodTypes
        ]
        
        Alamofire.request(baseUrlIntentString, method: .post, parameters: parameters, headers: headersWithStripeToken(secretKey)).responseJSON { (response) in
            switch response.result {
            case .success(let responseObject):
                if let responseArray = responseObject as? [String : AnyObject] {
                    
                    self.responseObject = self.parseResponse(responseArray)
                }
                else {
                    if let responseDictionary = responseObject as? [String : AnyObject] {
                        self.responseMessage = self.parseError(responseDictionary) ?? NSLocalizedString("Some error occured.", comment: "")
                    } else {
                        self.responseMessage = NSLocalizedString("Some error occured.", comment: "")
                    }
                }
                
            case .failure(let error):
                self.error = error as NSError?
            }
            closure(self)
        }
    }
    
    //MARK: - Private -
    
    func parseResponse(_ response: [String : AnyObject]) -> Intent? {
        return Intent(withDictionary: response)
    }
    
}
