//
//  Urls.swift
//  AroundEgypt
//
//  Created by Karim on 10/3/25.
//

import Foundation
class Urls {
    // Shared singleton instance
    static let shared = Urls()
    
    // Private initializer to prevent creating additional instances
    private init() {
    }
    
    private var baseUrl = "https://aroundegypt.34ml.com/api/v2/"
    
    var experiences: String {
            return baseUrl + "experiences"
    }
    
    var recommendedExperiences: String {
            return baseUrl + "experiences?filter[recommended]=true"
    }
}
