//
//  ContentView.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var search: String = ""
    var body: some View {
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
                    ForEach(1...1000, id: \.self) { item in
                        TableCell()
                        
                    }
                    
                }.frame(width: .infinity,height: 154)
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
