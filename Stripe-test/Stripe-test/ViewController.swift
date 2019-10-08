//
//  ViewController.swift
//  Stripe-test
//
//  Created by Constantine Likhachov on 10/8/19.
//  Copyright © 2019 Constantine Likhachov. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController {
    
    func callAPIToGetClientSecret(paymentMethod:String, paymentMethodParams: STPPaymentMethodParams)
    {
        let paymentRequest = PaymentRequest()
        
        paymentRequest.createSetupIntent { (result) in
            guard result.responseMessage == nil else { return }
            guard let resultRequest = result.responseObject else { return }
            print("client_secret = \(resultRequest.client_secret ?? "No client_secret")")
            self.confirmSetupIntents(clientSecret: resultRequest.client_secret!, paymentMethodId: paymentMethod)
        }
        
//        apiManager().callAPI(withURL: "YOUR_SERVER_URL", method: "GET", andParams: nil, showLoader: false) { (json:AnyObject, error:Bool) in
//            let client_secret = (json as! NSDictionary).value(forKey: "client_secret") as! String
        
    }
    
    
    // 5
    func confirmSetupIntents(clientSecret:String, paymentMethodId:String)
    {
        let setupIntentParams = STPSetupIntentConfirmParams(clientSecret:    clientSecret)
        setupIntentParams.paymentMethodID = paymentMethodId
        setupIntentParams.returnURL = "RETURN_URL" // to open your app after 3D authentication
        let paymentManager = STPPaymentHandler.shared()
        paymentManager.confirmSetupIntent(withParams: setupIntentParams, authenticationContext: self) { (status, setupIntent, error) in
            switch (status) {
            case .succeeded:
                print("succeeded")
                // Setup succeeded
                break
            case .canceled:
                // Handle cancel
                break
            case .failed:
                print("Error = \(String(describing: error))")
                // Handle error
                break
            @unknown default:
                print("Error")
            }
        }
    }
    
    
    func confirmPaymentIntents(clientSecret:String, paymentMethodId:String)
    {
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethodId
        paymentIntentParams.returnURL = "RETURN_URL" // to open your app after 3D authentication
        let paymentManager = STPPaymentHandler.shared()
        paymentManager.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status)
            {
            case .succeeded:
                // Setup succeeded
                break
            case .canceled:
                // Handle cancel
                break
            case .failed:
                // Handle error
                break
            @unknown default:
                print("Error")
            }
        }
    }
    
    @IBAction func payButton(_ sender: UIButton) {
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 10
        cardParams.expYear = 22
        cardParams.cvc = "123"
        let paymentMethodParams = STPPaymentMethodParams(
            card: cardParams,
            billingDetails: nil,
            metadata: nil
        )
        
        STPAPIClient.shared().createPaymentMethod(
            with: paymentMethodParams,
            completion: { paymentMethod, error in
                DispatchQueue.main.async {
                    if let paymentMethod = paymentMethod
                    {
                        print("ID: \(paymentMethod.stripeId)")
                        let payment_method = paymentMethod.stripeId
                        self.callAPIToGetClientSecret(paymentMethod: payment_method, paymentMethodParams: paymentMethodParams)
                    }
                    else
                    {
                        print("Error: \(String(describing: error))")
                    }
                }
        })
    }
}

extension ViewController: STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
}


