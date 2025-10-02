//
//  TouristPlacesViewModel.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import Foundation
class PlacesViewModel:ObservableObject{
    @Published var places:[Place] = []
    @Published var isLoading = false
    
    func getPlaces(){
        isLoading = true
       
    }
}
