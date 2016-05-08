//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 03/04/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit
import MessageUI

import LocalAuthentication


protocol SettingsTVCDataSource: class {
    func sliderCnt(cnt: Int,sender: SettingsTVC)
    func securitySwitched(isOn:Bool,sender:SettingsTVC)
    func qualityImageSwitched(isHigh:Bool,sender:SettingsTVC)
}

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {

    weak var dataSource: SettingsTVCDataSource?
    
    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedBackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var APICnt: UILabel!
    @IBOutlet weak var sliderCount: UISlider!
    @IBOutlet weak var bestImage: UISwitch!
    
    //User have to set this values in order to appear on screen, if not we'll put default values
    var touchIDisOn:Bool?
    var imageBestQualityisOn:Bool?
    var sliderCnt:Float?
    var touchIDAvailable:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Lo he cambiado en storyboard pero sino podrías poner (para que no se pueda hacer scroll):
        // tableView.alwaysBounceVertical = false
        
        self.title = "Settings"
        
        #if swift(>=2.2)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #endif
        

        
            
        //Settings initial parameters
        touchID.on = touchIDisOn ?? false
        bestImage.on = imageBestQualityisOn ?? false
        sliderCount.value = (sliderCnt ?? 10.0)
        APICnt.text = "\(Int(sliderCount.value))"
        
        // Check if the device has a fingerprint sensor and save it in a var called touchIDAvailable
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        
        var error:NSError?

        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            touchIDAvailable = false
            return
            
        }
    }
    
    @IBAction func finishedSliderValueChanged(sender: UISlider) {
        self.dataSource?.sliderCnt(Int(sliderCount.value), sender: self)
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        APICnt.text = ("\(Int(sender.value))")
    }
    
    @IBAction func imageQuality(sender: AnyObject) {
        self.dataSource?.qualityImageSwitched(bestImage.on, sender: self)
    }
    @IBAction func touchIDSec(sender: UISwitch) {
        self.dataSource?.securitySwitched(touchID.on, sender: self)
    }
    
    func preferredFontChange(){
        
        self.tableView.reloadData()
//        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        feedBackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            let mailComposeViewController = configureMail()
            
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController,  animated: true, completion: nil)
            }
            else
            {
                // No email account Setup on Phone
                mailAlert()
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        
        
    }
    
    func configureMail() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["f_navarro@me.com"])
        mailComposeVC.setSubject("Music Video App Feedback")
        mailComposeVC.setMessageBody("Hi Francisco,\n\nI would like to share the following feedback...\n", isHTML: false)
        return mailComposeVC
    }
    
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail Failed")
        default:
            print("Unknown Issue")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mailAlert() {
        
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "No e-Mail Account setup for Phone", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            //do something if you want
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: -
    //MARK: Table view data methods
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(section == 1){
            if(!self.touchIDAvailable){
                self.touchID.enabled = false
                return "Sorry, touch ID is not available in current device"
            }else{
                return nil
            }
        }else{
            return nil
        }
    }

    //MARK: -

    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
