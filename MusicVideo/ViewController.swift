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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    var limit:Int{
        set{
            if(newValue>API.maxNumVideos){
                self.limit = API.maxNumVideos
            }else{
                self.limit = newValue
            }
        }
        get{
            if let limite = (NSUserDefaults.standardUserDefaults().objectForKey(NSUserDefaultsKeys.apiCNT))
            {
                return Int(limite as! NSNumber)
            }else{
                return API.defaultNumVideos
            }
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Establecemos la delegación del tableView
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.addSubview(self.refreshControl)

     //   tableView.rowHeight = 139.0
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        reachabilityStatusChanged()
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        runAPI()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDte = formatter.stringFromDate(NSDate())
        
        refreshControl.attributedTitle = NSAttributedString(string: "\(refreshDte)")
        
        refreshControl.endRefreshing()
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
    
    func preferredFontChange(){
        print("font has changed")
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
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(self.limit)/json",completion:didLoadData)

    }
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)

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
   
    //MARK: - Navigation
    private struct identifiers {
        static let stringSegueIdentifier = "music detail"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier{
            case identifiers.stringSegueIdentifier:
                if let dvc = segue.destinationViewController as? MusicVideoDetailVC {
                    if let indexpath = tableView.indexPathForSelectedRow {
                        let video = videos[indexpath.row]
                        dvc.video = video
                    }
                }
            default: break

            }
            
        }
    }

    

}

