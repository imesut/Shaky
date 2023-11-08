//
//  ContentView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 5.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State var threshold = 0
    @State var displayGameLevel = false
    @State var showHelp = false
    
    var body: some View {
        if displayGameLevel{
            GameLevelView(gameLevel: gameLevels.first!)
            
        } else{
            VStack(spacing:20) {
                Button("Crash") {
                  fatalError("Crash was triggered")
                }
                
            HorizontalZigZagAnimatedComponent(child:
                    Image(systemName: "s.circle.fill").resizable().scaledToFit()
                        .frame(width: 120, height: 120)
                )
                fullWidthText(name: "shaky")
                
                VStack{
                    fullWidthText(name: "hit the wall,")
                    fullWidthText(name: "by jumping the ball,")
                    fullWidthText(name: "and keep your hand steady")
                }
                .padding(.horizontal)
                
                Button{ showHelp = true } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable().scaledToFit().frame(width: 40)
                        .foregroundColor(.accentColor)
                }
                
                Spacer()
                
                fullWidthTextWAction(name: "start") { displayGameLevel = true }
            }
            .padding()
            .sheet(isPresented: $showHelp, content: {
                HelpView(isDisplaying: $showHelp)
            })
        }
    }
}

#Preview {
    ContentView()
}
