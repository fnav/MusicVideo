    //
//  APIManager.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

    
    class APIManager {
        //MARK: APIManager methods
        //you pass the url with urlString and the completion for calling then data is loaded
        func loadData(urlString:String, completion: [Video] -> Void ) {
            
            //congig avoid to store data in cache
            let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            
            let session = NSURLSession(configuration: config)
            
            
            //unwrapped url
            let url = NSURL(string: urlString)!
            
            //dataTaskWithURL se llevará a cabo en segundo plano (no en el hilo principal)-> de ahí que cuando nos de los datos tengamos que volver al hilo principal
            let task = session.dataTaskWithURL(url) {
                (data, response, error) -> Void in
                
                if error != nil {
                    
                    print(error!.localizedDescription)
                    
                    
                } else {
                    
                    let videos = self.parseJson(data)
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(videos)
                        }
                    }
                }
                
            }
            
            task.resume()
        }
        
        func parseJson(data: NSData?) -> [Video] {
            
            do {
                
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as AnyObject? {
                    
                    return JsonDataExtractor.extractVideoDataFromJson(json)
                }
            }
                
            catch {
                print("Failed to parse data: \(error)")
            }
            
            return [Video]()
        }
        
        
    }
