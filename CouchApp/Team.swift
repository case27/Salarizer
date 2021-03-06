//
//  Team.swift
//  CouchApp
//
//  Created by Lap on 2014-07-21.
//  Copyright (c) 2014 Lap. All rights reserved.
//
import Foundation

class Team {
    
    var type : String?
    var city : String?
    var name : String?
    var location : String?
    var division : String?
    var conference : String?
    
    init(dict: Dictionary<String,String>) {
        type = dict["type"] as? String
        city = dict["city"] as? String
        name = dict["name"] as? String
        location = dict["location"] as? String
        division = dict["division"] as? String
        conference = dict["conference"] as? String
    }
    
    class func setObjectsWithConferenceWithClosure(conference: String,closure: ((data:[AnyObject]) -> ())?) {
        let url = NSURL(string: "http://127.0.0.1:5984/salarize/_design/api/_view/teams?include_docs=true")
        setObjectsWithURLWithClosure(url, { closure }())
        
    }
    
    class func setObjectsWithURLWithClosure(url: NSURL, closure: ((data:[AnyObject]) -> ())?) {
        
        var session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url, completionHandler:{(data: NSData!,
            response: NSURLResponse!,
            error: NSError!) in
            
            if error {
                println("API Error: \(error), \(error.userInfo)")
            }
            var jsonError: NSError?
            var json : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
            if jsonError {
                println("Error parsing json: \(jsonError)")
            }
            else {
                let results : NSArray = json["rows"] as NSArray
                if results.count > 0 {
                    var objects : [AnyObject] = []
                    for each : AnyObject in results {
                        if let dict = each["doc"] as? Dictionary<String,String> {
                            var object = Team(dict: dict)
                            objects.append(object)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        closure!(data:objects)
                    })
                }
            }
        
            }).resume()
    }
}
