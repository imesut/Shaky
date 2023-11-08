//
//  HelpView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 8.11.2023.
//

import SwiftUI

struct HelpView: View {
    @Binding var isDisplaying : Bool
    var body: some View {
        GeometryReader{ geo in
            VStack{
                HStack{
                    Spacer()
                    Button{
                        isDisplaying = false
                    } label: {
                        HStack{
                            Image(systemName: "xmark")
                            Text("Dismiss")
                        }
                    }
                    .padding(.all)
                }
                
                
                Text("Shaky").textCase(.uppercase).font(.title).padding(.all)
                
                Text("While playing this game, your ball will have a zig-zag movement while your hand is shaking.\n\n The more you shake, the ball will escape from the center further.\n\nYour target is to hit the wall, and complete the levels.").padding(.all).multilineTextAlignment(.center)
            
                
                
                HorizontalZigZagAnimatedComponent(child: Image(systemName: "volleyball.fill")
                .resizable().scaledToFit()
                .frame(width: 80, height: 80)
            )
            
            Spacer()
        }
        .frame(width: geo.size.width)
        //            .fixedSize(horizontal: true, vertical: false)
    }
}
}

#Preview {
    HelpView(isDisplaying: ContentView().$showHelp)
}
