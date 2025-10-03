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
        if(SQLiteDatabase.shared.fetchRecommendedPlaces().isEmpty){
            isLoading = true
            NetworkManager.shared.get(url: Urls.shared.recommendedExperiences, completion: {result in
                self.places=result
                
            })
        }else{
            self.places = SQLiteDatabase.shared.fetchRecommendedPlaces()
        }
    }
    
    
}

