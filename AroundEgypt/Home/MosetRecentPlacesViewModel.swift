//
//  TouristPlacesViewModel.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import Foundation
class MosetRecentPlacesViewModel:ObservableObject{
    @Published var places:[Place] = []
    @Published var isLoading = false
    
    func getMostRecentPlaces(){
        isLoading = true
        NetworkManager.shared.get(url: Urls.shared.experiences, completion: {result in
            self.places=result
            print(self.places)
        })
    }
    
    
}

