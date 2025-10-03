//
//  NetworkManager.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import Foundation
import Alamofire
class NetworkManager {
    // Shared singleton instance
    static let shared = NetworkManager()
    
    // Private initializer to prevent creating additional instances
    private init() {
    }
    
    func get(url:String, completion: @escaping ([Place])  -> Void){
        AF.request(url).responseDecodable(of: PlacesResponse.self) { response in
            switch response.result {
            case .success(let experienceResponse):
                // Successfully decoded ExperienceResponse object
                print("Successfully received data")
                
                // Access the experiences array
                let experiences = experienceResponse.data
                completion(experiences)
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
                
                // You can also check the response code
                if let statusCode = response.response?.statusCode {
                    print("Status code: \(statusCode)")
                }
                completion([])
            }
        }
            
        
    }
    
    func post(url:String, completion: @escaping (Int)  -> Void){
        AF.request(url,method: .post).responseDecodable(of: LikeResponse.self) { response in
            switch response.result {
            case .success(let likeResponse):
                // Successfully decoded ExperienceResponse object
                print("Successfully received data")
                
                // Access the experiences array
                let response = likeResponse.data
                completion(response)
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
                
                // You can also check the response code
                if let statusCode = response.response?.statusCode {
                    print("Status code: \(statusCode)")
                }
                completion(-1)
            }
        }
            
        
    }
    
    // Add your network methods here
}
