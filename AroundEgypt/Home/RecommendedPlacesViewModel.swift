//
//  TouristPlacesViewModel.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import Foundation
class RecommendedPlacesViewModel:ObservableObject{
    @Published var places:[Place] = []
    @Published var isLoading = false
    
    func getRecommendedPlaces(){
        isLoading = true
        NetworkManager.shared.get(url: Urls.shared.recommendedExperiences, completion: {result in
            self.places=result
            
        })
    }
    
    
}

