//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 03/04/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit
import MessageUI


protocol SettingsTVCDataSource: class {
    func sliderCnt(cnt: Int,sender: SettingsTVC)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Lo he cambiado en storyboard pero sino podrías poner (para que no se pueda hacer scroll):
        // tableView.alwaysBounceVertical = false
        
        self.title = "Settings"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey(NSUserDefaultsKeys.securitySettings)
        if let theValue = NSUserDefaults.standardUserDefaults().objectForKey(NSUserDefaultsKeys.apiCNT){
            APICnt.text = "\(theValue)"
            sliderCount.value = Float(theValue as! NSNumber)
        }
            
        
    }
    
    @IBAction func finishedSliderValueChanged(sender: UISlider) {
        self.dataSource?.sliderCnt(Int(sliderCount.value), sender: self)
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        APICnt.text = ("\(Int(sender.value))")
    }
    @IBAction func touchIDSec(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(touchID.on, forKey: NSUserDefaultsKeys.securitySettings)
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


    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
