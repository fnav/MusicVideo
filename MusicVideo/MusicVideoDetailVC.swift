//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 02/04/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

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
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        
        let url = NSURL(string: video.vVideoUrl)!
        
        let player = AVPlayer(URL: url)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player?.play()
        }

        
    }

    @IBAction func socialMedia(sender: UIBarButtonItem) {
        shareMedia()
    }
    
    
    func shareMedia() {
        
        let activity1 = "Have you had the opportunity to see this Music Video?"
        let activity2 = ("\(video.vName) by \(video.vArtist)")
        let activity3 = "Watch it and tell me what you think?"
        let activity4 = video.vLinkToiTunes
        let activity5 = "(Shared with the Music Video App - Step It UP!)"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4,activity5], applicationActivities: nil)
        
        //activityViewController.excludedActivityTypes =  [UIActivityTypeMail]
        
        //        activityViewController.excludedActivityTypes =  [
        //            UIActivityTypePostToTwitter,
        //            UIActivityTypePostToFacebook,
        //            UIActivityTypePostToWeibo,
        //            UIActivityTypeMessage,
        //            UIActivityTypeMail,
        //            UIActivityTypePrint,
        //            UIActivityTypeCopyToPasteboard,
        //            UIActivityTypeAssignToContact,
        //            UIActivityTypeSaveToCameraRoll,
        //            UIActivityTypeAddToReadingList,
        //            UIActivityTypePostToFlickr,
        //            UIActivityTypePostToVimeo,
        //            UIActivityTypePostToTencentWeibo
        //        ]
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityTypeMail {
                print ("email selected")
            }
            
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        
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
