//
//  TableCell.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import SwiftUI
import CachedAsyncImage
struct TableCell:View{
    var width:CGFloat
    var place:Place
    let optionsPressed: (String) -> Void?
    var body: some View {
        VStack{
            ZStack{
                CachedAsyncImage(url: URL(string: place.coverPhoto)) { phase in
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
                        }.frame(maxWidth: .infinity)
                VStack{
                    HStack{
                        if place.recommended == 1 {
                            HStack{
                                Image(uiImage: .icRecommended).resizable().frame(width: 9, height: 9).padding(.leading,8)
                                Text(LocalizedStringKey("recommended")).font(.custom("gotham-bold",size: 10)).padding(.trailing,8).foregroundColor(Color.white)
                            }.frame(height:17).background(Color.black.opacity(0.5)).cornerRadius(20).opacity((place.recommended == 1) ? 1 : 0)
                        }
                        Spacer()
                        Button("", image: .icInfo, action: {})
                    }
                    Spacer()
                    
                    Button("", image: .ic360, action: {})
                    
                    Spacer()
                    
                    HStack{
                        HStack{
                            Image(uiImage: .icEye).resizable().frame(width: 14, height: 10).padding(.leading,8)
                            Text("\(place.viewsNo)").font(.custom("gotham-bold",size: 14)).padding(.trailing,8).foregroundColor(Color.white)
                        }
                        Spacer()
                        Button("", image: .icMultiImages, action: {
                            optionsPressed("multiImages")
                        })
                    }
                    
                }.padding(.leading,8).padding(.trailing,4).padding(.vertical,8)
            }.frame(height: 154).cornerRadius(10)
            
            HStack{
                Text(place.title).font(.custom("gotham-bold",size: 10)).padding(.trailing,8).foregroundColor(Color.black)
                Spacer()
                HStack{
                    Text("\(place.likesNo)").font(.custom("gotham-medium",size: 14)).foregroundColor(Color.black)
                    Button("", image: (place.isLiked ?? false) ? .icLike : .icLikeOff, action: {
                        optionsPressed("like")
                    })
//                    Image(uiImage: ).resizable().frame(width: 20, height: 18)
                }
            
            }
        }.frame(width: width,height: 154)
    }
}

#Preview {
    //TableCell(width:UIScreen.main.bounds.width * 0.9)
}
