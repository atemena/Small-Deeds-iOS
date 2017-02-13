//
//  ClientApi.swift
//  Small Deeds
//
//  Created by Andrew Temena on 10/24/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class ClientAPI {
    let keychain = KeychainWrapper()
    func request(method: String, path: String?, params: Dictionary<String, AnyObject>?, completion: @escaping (_ success: Bool, _ data: JSON?) -> ()) {
        let path = path ?? ""
        switch method {
            case "post":
                post(request: clientURLRequest(path: "deeds/api/" + path, params: params)) { (success, object) -> () in
                    self.callback(success: success, object:object, completion: completion)
                }
            case "get":
                get(request: clientURLRequest(path: "deeds/api/" + path, params: params)) { (success, object) -> () in
                    self.callback(success: success, object:object, completion: completion)
                }
            case "put":
                put(request: clientURLRequest(path: "deeds/api/" + path, params: params)) { (success, object) -> () in
                    self.callback(success: success, object:object, completion: completion)
                }
            case "delete":
                delete(request: clientURLRequest(path: "deeds/api/" + path, params: params)) { (success, object) -> () in
                    self.callback(success: success, object:object, completion: completion)
                }
            default:
                return
        }
    }
    
    
    func getToken(params: Dictionary<String, AnyObject>?, completion: @escaping (_ success: Bool, _ data: JSON?) -> ()) {
        request(method: "post", path: "token-auth/", params: params, completion: completion)
    }
    
    func createPledge(params: Dictionary<String, AnyObject>?, completion: @escaping (_ success: Bool, _ data: JSON?) -> ()) {
        request(method: "post", path: "pledges/", params: params, completion: completion)
        
    }
    
    func updatePledge(params: Dictionary<String, AnyObject>?, completion: @escaping (_ success: Bool, _ data: JSON?) -> ()) {
        request(method: "put", path: "pledges/", params: params, completion: completion)
        
    }
    
    func deletePledge(params: Dictionary<String, AnyObject>?, completion: @escaping (_ success: Bool, _ data: JSON?) -> ()) {
        request(method: "delete", path: "pledges/", params: params, completion: completion)
        
    }
    
    func getDeeds(completion:@escaping (_ success: Bool, _ data: JSON?) -> ()){
        request(method: "get", path: "deeds/", params: nil, completion: completion)
    }
    
    func getPledges(params: Dictionary<String, AnyObject>?, completion: @escaping (_ success: Bool, _ data: JSON?) -> ()) {
        request(method: "get", path: "pledges/", params: params, completion: completion )
    }
    // MARK: private composition methods
    
    private func callback(success: Bool, object: JSON?, completion:@escaping (Bool, JSON) -> ()){
        DispatchQueue.main.async(execute: { () -> Void in
            if success {
                return completion(true, object!)
            } else {
                var message:JSON = ["message": "there was an error"]
                if let passedMessage = object?["message"].stringValue {
                    message = ["message": passedMessage]
                }
                return completion(true, message)
            }
        })
    }
    
    private func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: JSON?) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }
    
    private func put(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: JSON?) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }
    
    private func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: JSON?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    private func delete(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: JSON?) -> ()) {
        dataTask(request: request, method: "DELETE", completion: completion)
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: JSON?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    completion(true, JSON(json))
                } else {
                    completion(false, JSON(json))
                }
            }
            }.resume()
    }
    
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>?) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8000/"+path)! as URL)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = String(describing: value).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                paramString += "\(escapedKey!)=\(escapedValue!)&"
            }
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + (keychain.myObject(forKey: kSecValueData) as! String?)!, forHTTPHeaderField: "Authorization")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
            
        }
        return request
    }
}


