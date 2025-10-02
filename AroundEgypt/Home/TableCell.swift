//
//  TableCell.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import SwiftUI
struct TableCell:View{
    var width:CGFloat
    var body: some View {
        VStack{
            ZStack{
                Image("test_image").resizable().frame(maxWidth: .infinity)
                VStack{
                    HStack{
                        HStack{
                            Image(uiImage: .icRecommended).resizable().frame(width: 9, height: 9).padding(.leading,8)
                            Text(LocalizedStringKey("recommended")).font(.custom("gotham-bold",size: 10)).padding(.trailing,8).foregroundColor(Color.white)
                        }.frame(height:17).background(Color.black.opacity(0.5)).cornerRadius(20)
                        Spacer()
                        Button("", image: .icInfo, action: {})
                    }
                    Spacer()
                    
                    Button("", image: .ic360, action: {})
                    
                    Spacer()
                    
                    HStack{
                        HStack{
                            Image(uiImage: .icEye).resizable().frame(width: 14, height: 10).padding(.leading,8)
                            Text(LocalizedStringKey("150")).font(.custom("gotham-bold",size: 14)).padding(.trailing,8).foregroundColor(Color.white)
                        }
                        Spacer()
                        Button("", image: .icMultiImages, action: {})
                    }
                    
                }.padding(.leading,8).padding(.trailing,4).padding(.vertical,8)
            }.frame(height: 154).cornerRadius(10)
            
            HStack{
                Text(LocalizedStringKey("Nubian House")).font(.custom("gotham-bold",size: 10)).padding(.trailing,8).foregroundColor(Color.black)
                Spacer()
                HStack{
                    Text(LocalizedStringKey("372")).font(.custom("gotham-medium",size: 14)).foregroundColor(Color.black)
                    Image(uiImage: .icLike).resizable().frame(width: 20, height: 18)
                }
            
            }
        }.frame(width: width,height: 154)
    }
}

#Preview {
    TableCell(width:UIScreen.main.bounds.width * 0.9)
}
