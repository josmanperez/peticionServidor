//
//  NetworkOperation.swift
//  PeticionServidor
//
//  Created by Josman Pérez Expósito on 25/12/15.
//  Copyright © 2015 personal. All rights reserved.
//

import Foundation

class NetworkOperation {
  
  
  lazy var config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
  lazy var session:NSURLSession = NSURLSession(configuration: self.config)
  
  let queryURL:NSURL
  
  typealias JSONDictionaryCompletion = ([String:AnyObject]?) -> Void
  
  init(url: NSURL) {
    self.queryURL = url
  }
  
  
//  func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
//    
//    let request:NSURLRequest = NSURLRequest(URL: queryURL)
//    let dataTask = session.dataTaskWithURL(request) {
//      (let data, let response, let error) in
//      
//      if let httpResponse = response as? NSHTTPURLResponse {
//        
//        switch (httpResponse.statusCode) {
//        case 200:
//          let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String:AnyObject]
//          
//          completion(jsonDictionary)
//          
//        default:
//          print("ocurrio un error en la peticion GET")
//          
//        }
//        
//      } else {
//        print("No es valida la URL")
//      }
//    }
//  }
  
  
}