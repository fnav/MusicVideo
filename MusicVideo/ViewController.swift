//
//  ViewController.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let api = APIManager()
        api.loadData(API.DefaultsKey,completion:didLoadData)
        
    }
    
    func didLoadData(videos:[Video]){
        
       // for item in videos{
            //print("name = \(item.vName)")
       // }
        
        for (index,item) in videos.enumerate(){
             print("- \(index+1): Song name = \(item.vName)")
             print("            Price: \(item.vPrice)")
             print("            Artist: \(item.vArtist)")
        }
    }
    
   


    

}

