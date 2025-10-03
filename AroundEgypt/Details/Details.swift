//
//  Details.swift
//  AroundEgypt
//
//  Created by Karim on 10/3/25.
//

import Foundation
import SwiftUI

struct Details: View {
    var place: Place!
    let onLikesCountChanged: (Int) -> Void
    @StateObject private var likePlacesViewModel = LikePlacesViewModel()
    var body: some View {
        VStack{
            ZStack{
                AsyncImage(url: URL(string: place.coverPhoto)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView().foregroundColor(Color.blue)
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                VStack{
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.black, Color.black.opacity(0)]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(height: 60)
                }
                VStack{
                    Spacer()
                    Button("explore_now", action: {}).padding().background(Color.white).foregroundColor(Color(hex: "#F18757"))
                        .cornerRadius(7).font(.custom("gotham-bold", size: 14))
                    Spacer()
                    HStack{
                        HStack{
                            Image(uiImage: .icEye).resizable().frame(width: 14, height: 10).padding(.leading,8)
                            Text("\(place.viewsNo)").font(.custom("gotham-bold",size: 14)).padding(.trailing,8).foregroundColor(Color.white)
                        }
                        Spacer()
                        Button("", image: .icMultiImages, action: {})
                    }.padding([.bottom,.horizontal],8)
                }
            }.frame(maxWidth: .infinity).frame(height: 285).background(Color.gray)
            
            HStack{
                Text("\(place.title)").font(.custom("gotham-bold",size: 16)).padding(.trailing,8).foregroundColor(Color.black)
                Spacer()
                HStack{
                    Image( .icShare).resizable().frame(width: 16.39, height: 16.39).padding(.trailing,4)
                    
                    Button("", image: (place.isLiked ?? false) ? .icLike : .icLikeOff, action: {
                        likePlacesViewModel.likePressed(id: place.id, completion: {
                            SQLiteDatabase.shared.toggleLike(placeId: place.id,likeCount: likePlacesViewModel.likeCount)
                            onLikesCountChanged(likePlacesViewModel.likeCount)
                        })
                    }).frame(width: 20, height: 18).padding(.trailing,4)
                    
                    Text("\(likePlacesViewModel.likeCount)").font(.custom("gotham-medium",size: 14)).foregroundColor(Color.black).onAppear(perform:{
                        likePlacesViewModel.likeCount = place.likesNo
                    })
                }
            
            }.padding([.top,.leading,.trailing])
            HStack{
                Text(place.address).font(.custom("gotham-bold",size: 16)).padding(.trailing,8).foregroundColor(Color(hex: "555555"))
                Spacer()
            }.padding(.leading)
            
            Divider().padding()
            
            HStack{
                Text("description").font(.custom("gotham-bold",size: 16)).padding(.trailing,8).foregroundColor(Color.black)
                Spacer()
            }.padding(.leading)
            
            ScrollView(.vertical){
                Text(place.detailedDescription).font(.custom("gotham-medium",size: 14)).padding(.trailing,8).foregroundColor(Color.black)
            }.frame(maxWidth: .infinity).padding([.leading,.trailing])
        }
    }
}

#Preview {
    //Details()
}
