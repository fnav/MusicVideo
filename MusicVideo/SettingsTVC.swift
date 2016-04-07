//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 03/04/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit


protocol SettingsTVCDataSource: class {
    func sliderCnt(cnt: Int,sender: SettingsTVC)
}

class SettingsTVC: UITableViewController {

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
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
