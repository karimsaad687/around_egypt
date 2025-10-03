//
//  ContentView.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var search: String = ""
    @StateObject private var recommendedPlacesViewModel = RecommendedPlacesViewModel()
    @StateObject private var recentPlacesViewModel = MosetRecentPlacesViewModel()
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack{
                    Button("", image: .icMenu, action: {})
                    HStack{
                        Button("", image: .icSearch, action: {})
                        TextField(LocalizedStringKey("try_luxor"), text: $search)
                            .font(.system(size: 16))
                            .keyboardType(.numberPad)
                        
                            .foregroundColor(.black)
                            .padding()
                        
                            .cornerRadius(10)
                            .padding(.horizontal, -20)
                        
                    }.padding().frame(maxWidth: .infinity).frame(height: 36).background(Color(hex: "#8E8E93").opacity(0.12)).cornerRadius(10)
                    Spacer(minLength: 16)
                    Button("", image: .icFilter, action: {})
                }
                
                Text(LocalizedStringKey("welcome")).font(.custom("gothamrounded-bold",size: 24)).padding(.top, 24)
                Text(LocalizedStringKey("greeting")).font(.custom("gotham-medium",size: 14)).padding(.top, 1)
                
                Text(LocalizedStringKey("recommended_experiences")).font(.custom("gotham-bold",size: 22)).padding(.top, 16)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10){
                        ForEach(recommendedPlacesViewModel.places, id: \.id) { place in
                            TableCell(width: UIScreen.main.bounds.width * 0.8,place: place)
                            
                        }
                        
                    }.frame(maxWidth: .infinity).frame(height: 180)
                        .onAppear(perform: {
                        recommendedPlacesViewModel.getRecommendedPlaces()
                    })
                }
                Text(LocalizedStringKey("most_recent")).font(.custom("gotham-bold",size: 22)).padding(.top, 16)
                
                LazyVStack(spacing: 22){
                    ForEach(recentPlacesViewModel.places, id: \.id) { place in
                        TableCell(width: UIScreen.main.bounds.width * 0.9,place: place)
                        
                    }.padding(.top, 12)
                       
                        
                    
                }.frame(maxWidth: .infinity).padding(.bottom,16) .onAppear(perform: {
                    recentPlacesViewModel.getMostRecentPlaces()
                })
                
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
