//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 30/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {
    
    
    var video: Video?{
        didSet{
            updateCell()
        }
    }

    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var musicTitle: UILabel!
    
    func updateCell() {
        musicTitle.text = video?.vName
        rank.text = ("\(video!.vRank)")
        
        musicImage.image = UIImage(named:"imageNotAvailable")
    }
    
}
