//
//  ViewController.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import UIKit

var imageQuality:ImageQualityType = ImageQualityType.medium

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsTVCDataSource,UISearchResultsUpdating{
    
    //MARK: -
    //MARK: Parameters
    
    //As you can imagine by his name, musicVideoDefaults store default parameters values as bestQuality, security, video count, etc.
    var musicVideoDefaults = MusicVideoDefaults.sharedInstance
    
    //Table model variables
    var filterSearch = [Video]()
    var videos = [Video]()
    
    //Outlets
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    

     //Specify nil if you want to display the search results in the same view controller that displays your searchable content.
    let resultSearchController = UISearchController(searchResultsController: nil)

    //Everytime the imageQuality has change, we want our videos urls and data to be updated if necessary
    private var _imageQuality:ImageQualityType?{
        didSet{
            if(_imageQuality?.rawValue != imageQuality.rawValue){
                //Reload videos
                print("Video quality has changed to \(_imageQuality!.rawValue):\(_imageQuality!.description)")
                
                //set global imageQuality for accessing from other classes
                imageQuality = _imageQuality!
                
                
                //Let our video knows that the image quality has change
                for video in self.videos{
                    video.vImageQuality = _imageQuality!
                }
                
                
            }else{
                print("Video quality remain the same \(_imageQuality!.rawValue):\(_imageQuality!.description)")
            }
        }
    }
    
    //store number of videos in list
    var limit:Int{
        set{
            //If videos' number has change we want to modify its value in defaults and let our controller know that needs to reload when its view is back
            if(newValue != musicVideoDefaults.limit){
                musicVideoDefaults.limit = newValue
                needReloadData = true
            }
        }
        get{
            return musicVideoDefaults.limit
        }
    }
    
    //check viewDidAppear to know needReloadData job
    var needReloadData = false

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Everytime view appear we'll check if we need to reload our data
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

        //Navigation controller color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]

        //add notification observers
        //notification for changes in internet status
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        //notification if user change the font in iphone settings
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        //We want to set initial internet value
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
    
    //MARK: -
    //MARK: Methods called from notification center
    
    func reachabilityStatusChanged()
    {
        switch reachabilityStatus {
        case InternetStatus.WIFI :
            //If Wifi is active and bestImageQuaility is set, we'll get the highest quality possible
            if(musicVideoDefaults.bestQuality){
               _imageQuality = ImageQualityType.best
            }else{
                _imageQuality = ImageQualityType.medium
            }
            
            if self.videos.count == 0 {runAPI()}
            
        case InternetStatus.WWAN :
            //In this case we'll always use the lowest quality
            _imageQuality = ImageQualityType.low
            
            if self.videos.count == 0 {runAPI()}

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
      
        //Switch end
        }
    }
    
    func preferredFontChange(){
        print("font has changed")
    }
    
    //MARK: -
    
    //MARK: View Controller methods
    
    //This method is called asynchronously by APIManager when data is loaded
    func didLoadData(videos: [Video]){
        
        //Set the model of our tableView
        self.videos = videos
        
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
        // Put comment in search controller bar
        resultSearchController.searchBar.placeholder = "Search for Artist, Name or Rank"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        
        // add the search bar to your tableview
        tableView.tableHeaderView = resultSearchController.searchBar
        
        //recargo la tabla para que muestre los datos
        tableView.reloadData()
    }
    
    //In this method we'll check the corresponding image's quality based on the internet status
    func checkImageQuality() {
        
        switch reachabilityStatus {
            
        case InternetStatus.WIFI :
            //If Wifi is active and bestImageQuaility is set, we'll get the highest quality possible
            if(musicVideoDefaults.bestQuality){
                _imageQuality = ImageQualityType.best
            }else{
                _imageQuality = ImageQualityType.medium
            }
        case InternetStatus.WWAN :
            //In this case we'll always use the lowest quality
            _imageQuality = ImageQualityType.low
        default: print("Image quality checked without changes")
            
        }
        
    }
    
    //Call runAPI when you want to load best videos from itunes server
    func runAPI(){
        
        //If refreshControl is stopped, show spinner instead
        if (!self.refreshControl.refreshing) {
            self.spinner.startAnimating()
        }
        
        //Load data from our APIManager class
        let api = APIManager()
        let url = "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(self.limit)/json"
        api.loadData(url,completion: didLoadData)
    }
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)

    }
    
    //MARK: -

    // MARK: UITableViewDataSource
    
    //By now we just wank to have a section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //Depending on whether the resultController is active or not we want a different number of video's rows
        if resultSearchController.active {
            return self.filterSearch.count
        }
        return self.videos.count
    }
    
    
    private struct storyBoard{
        static let cellReuseIdentifier = "cell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Configure the cell
        let cell = tableView.dequeueReusableCellWithIdentifier(storyBoard.cellReuseIdentifier,forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        //Depending on whether the resultController is active or not we want a different model
        if resultSearchController.active {
            cell.video = self.filterSearch[indexPath.row]
        } else {
            cell.video = self.videos[indexPath.row]
        }
        return cell
        
    }
    //MARK: -
    
    // MARK: UITableViewDelegate
   

    //MARK: - Navigation
    
    //Posible navigation identifiers
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
                        
                        //If it's Detail Video view controller we set the proper video
                        let video: Video
                        if resultSearchController.active {
                            video = self.filterSearch[indexpath.row]
                            
                        } else {
                            video = self.videos[indexpath.row]
                        }
                        
                        dvc.video = video
                    }
                }
            case identifiers.settingsIdentifier:
                if let svc = segue.destinationViewController as? SettingsTVC {
                    svc.dataSource = self
                    
                    //Set initial values for settings view controller
                    svc.sliderCnt = Float(musicVideoDefaults.limit)
                    svc.touchIDisOn = musicVideoDefaults.security
                    svc.imageBestQualityisOn = musicVideoDefaults.bestQuality
                    
                }
            default: break

            }
            
        }
    }
    
  
    //MARK: -

    //MARK: SettingsTVCDataSource methods
    
    //Slider in Settings view controller has changed
    func sliderCnt(cnt: Int, sender: SettingsTVC) {
        print("Slider cambiado a \(cnt)")
        self.limit = cnt
    }
    
    //Quality switch in settings view controller has changed
    func qualityImageSwitched(isHigh: Bool, sender: SettingsTVC) {
        self.musicVideoDefaults.bestQuality = isHigh
        
        //As image quality switch has changed, we need to check the vImageQuality var
        checkImageQuality()
    }
    
    //Security switch in settings view controller has changed
    func securitySwitched(isOn: Bool, sender: SettingsTVC) {
        self.musicVideoDefaults.security = isOn
    }
    
    //MARK: -

    //MARK: UISearchResultsUpdating delegate:
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        filterSearch(searchController.searchBar.text!)
    }
    
    //set our search videos model based on user's quest
    func filterSearch(searchText: String) {
        filterSearch = self.videos.filter { videos in
            return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString) || videos.vName.lowercaseString.containsString(searchText.lowercaseString) || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }


}

