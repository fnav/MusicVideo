//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 02/04/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit

class MusicVideoDetailVC: UIViewController {

    var video:Video!
    
    //MARK: Outlets
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDetailView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDetailView(){
        
            title = video.vArtist
            vName.text = video.vName
            vPrice.text = video.vPrice
            vRights.text = video.vRights
            vGenre.text = video.vGenre
            
            if video.vImageData != nil {
                videoImage.image = UIImage(data: video.vImageData!)
            }
            else {
                videoImage.image = UIImage(named: "imageNotAvailable")
            }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
