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

func fullWidthTextWAction(name : String, action : @escaping (()->()) = {} ) -> some View {
    
    return Text(name.uppercased())
        .font(.system(size: 300))
        .underline()
        .minimumScaleFactor(0.01)
        .lineLimit(1)
        .lineSpacing(-10)
        .onTapGesture {
            action()
        }
        .padding()
}

#Preview {
    VStack(spacing: 0){
        fullWidthTextWAction(name: "start start start")
        fullWidthText(name: "start")
    }
}
