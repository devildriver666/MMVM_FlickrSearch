//
//  FlikerNetworkingClient.swift
//  FlikerSearch
//
//  Created by Abhijeet on 11/06/17.
//  Copyright © 2017 Abhijeet. All rights reserved.
//

import Foundation

class FlickrNetworkingClient: NSObject {
    
    func fetchSearchResult(searchString:String, pageNumber:String , _ completion: @escaping (Bool,[NSDictionary]?) -> ()) {
        //fetch results
        let urlString = APIConstants.flikrSearchUri + "&page=\(pageNumber)&per_page=21&text=\(searchString)"
       
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            // check for any errors
            guard error == nil else {
                print("error calling GET on /data")
                print(error ?? "Error")
                completion(false,nil)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                completion(false,nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary {
                print("JSON -> \(String(describing: json))")
                    if let photosJson = json.value(forKeyPath: "photos.photo") as? [NSDictionary] {
                        completion(true,photosJson)
                    }
                }
            } catch {
                print("Error -> \(error)")
            }
            
            // parse the result as JSON, since that's what the API provides""
        })
        task.resume()
    }
}

