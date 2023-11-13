//
//  ball.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 13.11.2023.
//

import SwiftUI

struct ball: View {
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{
                ZStack{
                    Image(systemName: "volleyball.fill").resizable().scaledToFit()
                        .frame(height: 100)
                        .background(Color.red)
                    
                    Circle().frame(width: 10, height: 10)
                        .foregroundColor(.white)
                }
                .ignoresSafeArea()
//                .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                
                Rectangle().frame(width: 1, height: 2000)
                    .background(Color.black)
                    .position(x: geometry.size.width / 2 - 0.5)
                
                Rectangle().frame(width: 1000, height: 1)
                    .background(Color.black)
                    .position(y: geometry.size.height / 2 - 0.5)
            }
        })
        .ignoresSafeArea()
        

    }
}

#Preview {
    ball()
}
