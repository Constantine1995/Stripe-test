//
//  ViewController.swift
//  Stripe-test
//
//  Created by Constantine Likhachov on 10/8/19.
//  Copyright © 2019 Constantine Likhachov. All rights reserved.
//

import UIKit
import Stripe
import SVProgressHUD

class ViewController: UIViewController {
    
    func showActivityIndicator() {
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 0))
        SVProgressHUD.show()
    }
    
    func hideActivityIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func callAPIToGetClientSecret(paymentMethod:String, paymentMethodParams: STPPaymentMethodParams)
    {
        let paymentRequest = PaymentRequest()
        
        paymentRequest.createSetupIntent { (result) in
            guard result.responseMessage == nil else { return }
            guard let resultRequest = result.responseObject else { return }
            print("client_secret = \(resultRequest.client_secret ?? "No client_secret")")
            self.confirmSetupIntents(clientSecret: resultRequest.client_secret!, paymentMethodId: paymentMethod)
        }
    }
    
    
    // 5
    func confirmSetupIntents(clientSecret: String, paymentMethodId: String)
    {
        let paymentRequest = PaymentRequest()

        let setupIntentParams = STPSetupIntentConfirmParams(clientSecret: clientSecret)
        setupIntentParams.paymentMethodID = paymentMethodId
        let paymentManager = STPPaymentHandler.shared()
        paymentManager.confirmSetupIntent(withParams: setupIntentParams, authenticationContext: self) { (status, setupIntent, error) in
            switch (status) {
            case .succeeded:
                print("succeeded")
                paymentRequest.customerSetupIntent(paymentMethodID: paymentMethodId)
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
        showActivityIndicator()
        
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = "4000000000003220"
        cardParams.expMonth = 10
        cardParams.expYear = 23
        cardParams.cvc = "122"
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


