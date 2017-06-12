//
//  Helper.swift
//  FlikerSearch
//
//  Created by Abhijeet on 11/06/17.
//  Copyright © 2017 Abhijeet. All rights reserved.
//

import Foundation

public struct APIConstants {
    
    static let baseUri = "https://api.flickr.com"
    static let path = "/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1"
    static let flikrSearchUri = baseUri + path
}
