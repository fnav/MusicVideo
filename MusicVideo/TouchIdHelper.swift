//
//  TouchIdHelper.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 5/5/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIdHelper: NSObject {
    static func userAuthenticate(completion: (success: Bool, alert: UIAlertController) -> Void) {
        // Create an alert
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "continue", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // Create the Local Authentication Context
        let context = LAContext()
        var touchIDError : NSError?
        let reasonString = "Touch-Id authentication is needed to share info on Social Media"
        
        // Check if we can access local device authentication
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            // Check what the authentication response was
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                if success {
                    completion(success: true, alert: alert)
                } else {
                    
                    alert.title = "Unsuccessful!"
                    
                    switch LAError(rawValue: policyError!.code)! {
                        
                    case .AppCancel:
                        alert.message = "Authentication was cancelled by application"
                        
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                        
                    case .PasscodeNotSet:
                        alert.message = "Passcode is not set on the device"
                        
                    case .SystemCancel:
                        alert.message = "Authentication was cancelled by the system"
                        
                    case .TouchIDLockout:
                        alert.message = "Too many failed attempts."
                        
                    case .UserCancel:
                        alert.message = "You cancelled the request"
                        
                    case .UserFallback:
                        alert.message = "Password not accepted, must use Touch-ID"
                        
                    default:
                        alert.message = "Unable to Authenticate!"
                        
                    }
                    
                    completion(success: false, alert: alert)
                }
            })
        } else {
            // Unable to access local device authentication
            
            // Set the error title
            alert.title = "Error"
            
            // Set the error alert message with more information
            switch LAError(rawValue: touchIDError!.code)! {
                
            case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
                
            case .TouchIDNotAvailable:
                alert.message = "TouchID is not available on the device"
                
            case .PasscodeNotSet:
                alert.message = "Passcode has not been set"
                
            case .InvalidContext:
                alert.message = "The context is invalid"
                
            default:
                alert.message = "Local Authentication not available"
            }
            
            completion(success: false, alert: alert)
        }
        
    }
}