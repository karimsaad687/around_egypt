//
//  TouristPlacesViewModel.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import Foundation
class LikePlacesViewModel:ObservableObject{
    @Published var likeCount = -1
    @Published var isLoading = false
    
    func likePressed(id:String,completion: @escaping () -> Void){
        NetworkManager.shared.post(url: Urls.shared.experiences+"/\(id)/like", completion: {result in
            self.likeCount=result
            completion()
        })
    }
}

