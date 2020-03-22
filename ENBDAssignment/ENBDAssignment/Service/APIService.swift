//
//  APIService.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import Foundation
import Reachability

typealias JSON = [String: Any]

final class APIService: NSObject {
    public static let shared = APIService()
    private let baseURL = "https://pixabay.com/api/"
    private let apiKey = "15683635-425a9a1c6515a6813afa9b4d6"
    private var dataTask: URLSessionDataTask?
    
    func search(keyWord: String, completion: @escaping ([Photo]?, ServiceError?) -> ()) {
        
     getData(searchQuery: keyWord) { (result, error) in
        let dictionaries = result as? NSDictionary
        let hits = dictionaries?.value(forKey: "hits") as? [JSON]
        completion(hits?.compactMap(Photo.init), error)
        }
        
    }
    
    func getData(searchQuery: String, completion: @escaping (Any?, ServiceError?) -> ()) {
        
        // Checking Network Connectivity
        if !isNetworkAvailable() {
            completion(nil, ServiceError.noInternetConnection)
            return
        }
        
        // Creating the URLRequest object
        let urlString = baseURL + "?key=" + apiKey + "&image_type=photo&q=" + searchQuery
        guard let url = URL(string: urlString) else {
            completion(nil, ServiceError.other)
            return
            
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Sending request to the server.
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                self.dataTask = nil
            }
            // Parsing incoming data
            var object: NSDictionary? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, nil)
            } else {
                let error = (object as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                completion(nil, error)
            }
        }
        
        dataTask?.resume()
    }
    
    private func isNetworkAvailable() -> Bool {
           
           let reachability = try? Reachability.init()
           return reachability?.connection != .unavailable
       }
}
