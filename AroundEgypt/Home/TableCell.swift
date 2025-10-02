//
//  TableCell.swift
//  AroundEgypt
//
//  Created by Karim on 10/2/25.
//

import SwiftUI
struct TableCell:View{
    var body: some View {
        ZStack{
            Image("test_image").resizable().frame(width: .infinity)
                
        }.frame(width: UIScreen.main.bounds.width * 0.8).background(Color.blue).cornerRadius(10)
        
    }
}

#Preview {
    TableCell()
}
