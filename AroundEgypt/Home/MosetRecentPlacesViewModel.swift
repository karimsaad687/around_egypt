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
        if(SQLiteDatabase.shared.fetchAllPlaces().isEmpty){
            isLoading = true
            NetworkManager.shared.get(url: Urls.shared.experiences, completion: {result in
                self.places=result
                SQLiteDatabase.shared.savePlaces(result)
                print(self.places)
            })
        }else{
            self.places = SQLiteDatabase.shared.fetchAllPlaces()
            
        }
    }
    
    func getMostRecentPlaces(searchWord:String){
        self.places = SQLiteDatabase.shared.searchPlacesByTitle(searchWord)
    }
    
    
}

