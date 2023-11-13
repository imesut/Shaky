//
//  ViewComponents.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 5.11.2023.
//

import SwiftUI

func fullWidthText(name: String) -> some View{
    return Text(name.uppercased())
        .font(.system(size: 300))
        .lineLimit(1)
        .minimumScaleFactor(0.01)
}

func fullWidthTextButton(name : String, action : @escaping (()->()) = {} ) -> some View {
    return orangeUnderline(
        body: Button(action: {
            action()
        }, label: {
            Text(name.uppercased())
                .font(.system(size: 300))
                .lineLimit(1)
                .lineSpacing(-10)
        }).foregroundColor(Color.primary)
    )
    .minimumScaleFactor(0.01)
    .padding()
}


func orangeUnderline(body : some View) -> some View{
    return VStack(spacing: 0){
        body
        RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 4).foregroundColor(.orange)
    }
}


#Preview {
    VStack(spacing: 0){
        fullWidthTextButton(name: "start start start")
        fullWidthText(name: "start")
    }
}
