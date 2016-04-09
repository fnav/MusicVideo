//
//  ViewController.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsTVCDataSource,UISearchResultsUpdating{
    
    var musicVideoBrain = MusicVideoBrain.sharedInstance

    @IBOutlet weak var displayLabel: UILabel!
    
    var videos = [Video]()
    var filterSearch = [Video]()
    
        //Specify nil if you want to display the search results in the same view controller that displays your searchable content.
    let resultSearchController = UISearchController(searchResultsController: nil)

    
    var limit:Int{
        set{
            if(newValue != musicVideoBrain.limit){
                musicVideoBrain.limit = newValue
                needReloadData = true
            }
        }
        get{
            return musicVideoBrain.limit
        }
    }
    var needReloadData = false
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if reloadData is necessary
        if(needReloadData){
            runAPI()
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Establecemos la delegación del tableView
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.addSubview(self.refreshControl)

     //   tableView.rowHeight = 139.0
        //Navigation controller color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]

        
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
        
        
        //Stop either resfresh or spinner
        if (refreshControl.refreshing){
            refreshControl.endRefreshing()
        }else{
            self.spinner.stopAnimating()
        }
        needReloadData = false
        
        //Change Navigation controller title
        title = ("The iTunes Top \(limit) Music Videos")

        
        // Setup the Search Controller
        
        resultSearchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        resultSearchController.searchBar.placeholder = "Search for Artist, Name or Rank"
        
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        
        // add the search bar to your tableview
        tableView.tableHeaderView = resultSearchController.searchBar

        
        //recargo la tabla para que muestre los datos
        tableView.reloadData()
    }
    
    func runAPI(){
        
        //If refreshControl is stopped, show spinner instead
        if (!self.refreshControl.refreshing) {
            self.spinner.startAnimating()
        }
        
        let api = APIManager()
        let url = "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(self.limit)/json"
        api.loadData(url,completion:didLoadData)

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
        
        if resultSearchController.active {
            return filterSearch.count
        }
        return videos.count    }
    
    
        private struct storyBoard{
        static let cellReuseIdentifier = "cell"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyBoard.cellReuseIdentifier,forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        if resultSearchController.active {
            cell.video = filterSearch[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]
        }
        return cell
        
    }
    
    // MARK: UITableViewDelegate
   
    //MARK: - Navigation
    private struct identifiers {
        static let musicDetailIdentifier = "music detail"
        static let settingsIdentifier = "settingsTVC"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier{
            case identifiers.musicDetailIdentifier:
                if let dvc = segue.destinationViewController as? MusicVideoDetailVC {
                    if let indexpath = tableView.indexPathForSelectedRow {
                        
                        let video: Video
                        if resultSearchController.active {
                            video = filterSearch[indexpath.row]
                            
                        } else {
                            video = videos[indexpath.row]
                        }
                        
                        dvc.video = video
                    }
                }
            case identifiers.settingsIdentifier:
                if let svc = segue.destinationViewController as? SettingsTVC {
                    svc.dataSource = self
                    
                    //Set initial values:
                    svc.sliderCnt = Float(musicVideoBrain.limit)
                    svc.touchIDisOn = musicVideoBrain.security
                    svc.imageBestQualityisOn = musicVideoBrain.bestQuality
                    
                }
            default: break

            }
            
        }
    }
    
    //MARK: SettingsTVCDataSource methods
    func sliderCnt(cnt: Int, sender: SettingsTVC) {
        print("Slider cambiado a \(cnt)")
        self.limit = cnt
    }
    
    func qualityImageSwitched(isHigh: Bool, sender: SettingsTVC) {
        self.musicVideoBrain.bestQuality = isHigh
    }
    
    func securitySwitched(isOn: Bool, sender: SettingsTVC) {
        self.musicVideoBrain.security = isOn
    }
    
    //MARK UISearchResultsUpdating delegate:
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    searchController.searchBar.text!.lowercaseString
    filterSearch(searchController.searchBar.text!)
    }
    
    func filterSearch(searchText: String) {
        filterSearch = videos.filter { videos in
            return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString) || videos.vName.lowercaseString.containsString(searchText.lowercaseString) || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }


}

