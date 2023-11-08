//
//  HorizontalZigZagAnimatedComponent.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 8.11.2023.
//

import SwiftUI

struct HorizontalZigZagAnimatedComponent<Content : View>: View {
    @State fileprivate var zigzagAnimationUnit : CGFloat = -50
    var speed : Double = 1
    var maxShift : Double = 50
    let child : Content
    
    var body: some View {
        HStack{
            child
                .padding(.leading, zigzagAnimationUnit)
                .onAppear{
                    withAnimation(.linear.speed(speed).repeatForever()){
                        zigzagAnimationUnit = maxShift
                    }
                }
        }
    }
}

#Preview {
    HorizontalZigZagAnimatedComponent(child: Text("HW"))
}
