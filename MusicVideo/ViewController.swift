//
//  ViewController.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        
        reachabilityStatusChanged()

        
        
        let api = APIManager()
        api.loadData(API.DefaultsKey,completion:didLoadData)
        
    }
    
    func reachabilityStatusChanged()
    {
        
        switch reachabilityStatus {
        case InternetStatus.NOACCESS: view.backgroundColor = UIColor.redColor()
        case InternetStatus.WIFI : view.backgroundColor = UIColor.greenColor()
        case InternetStatus.WWAN : view.backgroundColor = UIColor.yellowColor()
        }
        displayLabel.text = reachabilityStatus.description
    }
    
    func didLoadData(videos:[Video]){
        
       // for item in videos{
            //print("name = \(item.vName)")
       // }
        
        for (index,item) in videos.enumerate(){
             print("- \(index+1): Song name = \(item.vName)")
             print("            Price: \(item.vPrice)")
             print("            Artist: \(item.vArtist)")
             print("            ReleaseDate: \(item.vReleaseDte)")

        }
    }
    
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    
   


    

}

