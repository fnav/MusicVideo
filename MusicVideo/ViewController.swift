//
//  ViewController.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var displayLabel: UILabel!
    
    var videos = [Video]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Establecemos la delegación del tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 139.0
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        
        reachabilityStatusChanged()
        
    }
    
    func reachabilityStatusChanged()
    {
        
        switch reachabilityStatus {
        case InternetStatus.NOACCESS:
          //  view.backgroundColor = UIColor.redColor()
            
            let alert = UIAlertController(title: reachabilityStatus.description, message: "Please make sure you are connected to the Internet",preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default){
                action -> () in
                
                print("Cancel")
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive){
                action -> () in
                
                print("Delete")
            }
            
            let okAction = UIAlertAction(title: "ok", style: .Default){
                action -> () in
                
                print("Ok")
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            alert.addAction(okAction)
            
            dispatch_async(dispatch_get_main_queue()){
                //Tengo que hacerlo de forma asincrona pues reachabilityStatusChanged() es llamado en el viewDidLoad cuando la vista no se ha cargado por completo y no puedes añadir algo a la vista cuando aun ni ha aparecido. Si lo haces asincronamente la alerta se añadira despues de cargar la vista. Es decir, se hace asincronamente y cuando se añade a la vista le ha dado tiempo a cargarse
                self.presentViewController(alert, animated: true,completion: nil)
            }
        //case InternetStatus.WIFI : view.backgroundColor = UIColor.greenColor()
        //case InternetStatus.WWAN : view.backgroundColor = UIColor.yellowColor()
        default:
           // view.backgroundColor = UIColor.greenColor()
            if videos.count > 0{
                print ("Do not refresh API")
            }else{
                runAPI()
            }
            
        }
    }
    
    func didLoadData(videos:[Video]){
        
       // for item in videos{
            //print("name = \(item.vName)")
       // }
        self.videos = videos
        
        for (index,item) in videos.enumerate(){
             print("- \(index+1): Song name = \(item.vName)")
             print("            Price: \(item.vPrice)")
             print("            Artist: \(item.vArtist)")
             print("            ReleaseDate: \(item.vReleaseDte)")

        }
        //recargo la tabla para que muestre los datos
        tableView.reloadData()
    }
    
    func runAPI(){
        
        let api = APIManager()
        api.loadData(API.DefaultsKey,completion:didLoadData)

    }
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    // MARK: UITableViewDataSource
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    
    private struct storyBoard{
        static let cellReuseIdentifier = "cell"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyBoard.cellReuseIdentifier,forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        cell.video = videos[indexPath.row]
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate
   


    

}

