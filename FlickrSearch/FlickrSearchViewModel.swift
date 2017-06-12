//
//  FlikerSearchViewModel.swift
//  FlikerSearch
//
//  Created by Abhijeet on 11/06/17.
//  Copyright © 2017 Abhijeet. All rights reserved.
//

import UIKit

class FlickrSearchViewModel: NSObject {
    
    var completionClosure : ((Bool) -> Void) = { _ in }
    
    @IBOutlet var flickerClient: FlickrNetworkingClient! //Dependency injection through story board.
    //var photosObject: [NSDictionary]?
    var photosArray = [String]()

    //Call for serach API call.
    func fetchSearchResult(_ searchString:String, pageNumber:String) {
        flickerClient.fetchSearchResult(searchString: searchString, pageNumber: pageNumber, {[unowned self] (success, photos) in
           // self.photosObject = photos
            if success {
                if let photosArray = photos {
                    self.prepareImageArray(objectArray: photosArray)
                }
            } else {
               self.completionClosure(false)
            }
        })
    }
    func numberOfItemsInSection(_ section: Int) -> Int {
        return photosArray.count
    }
    
    //Prepare ViewModel for the View.
    func prepareImageArray(objectArray:  [NSDictionary]) {
        //Prepare Array
        for object in objectArray {
            let id = object.value(forKey: "id")
            let farm = object.value(forKey: "farm")
            let server = object.value(forKey: "server")
            let secret = object.value(forKey: "secret")
            
            //Few things can be moved to constant but leave it for now.
            let imageUrl = "https://farm\(String(describing: farm!)).static.flickr.com/\(String(describing: server!))/\(String(describing: id!))_\(String(describing: secret!)).jpg"
            self.photosArray.append(imageUrl)
        }
        completionClosure(true)
    }
    
    func urlForTheItemAtIndexPath(_ indexPath: IndexPath) -> String{
        return photosArray[indexPath.row]
    }
    
    func clearHistorySearch() {
        self.photosArray.removeAll()
    }
}
