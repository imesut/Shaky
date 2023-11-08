//
//  ContentView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 5.11.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var accModel = AccelerometerModel()
    @State var threshold = 0
    @State var displayGameLevel = false
    @State var showHelp = false
    
    var body: some View {
        if displayGameLevel{
            GameLevelView(/*showLevel: $displayGameLevel,*/ acceleration: $accModel.netAccP)
            
        } else{
            VStack(spacing:20) {
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
                
//                Spacer()
//                if($accModel.diffNetAcc.wrappedValue > $threshold.wrappedValue){
//                    fullWidthTextWAction(name: String($accModel.diffNetAcc.wrappedValue))
//                }
//                
//                Spacer()
//                
//                Stepper(value: $threshold, in: -5...20) {
//                    Text("Threshold " + String($threshold.wrappedValue))
//                }
                
                fullWidthTextWAction(name: "start") { displayGameLevel = true }
            }
            .padding()
            .onAppear{
                accModel.startAccelerometers()
            }
            .onDisappear{
//                accModel.stopAccelerometers()
            }
            .sheet(isPresented: $showHelp, content: {
                HelpView(isDisplaying: $showHelp)
            })
        }
    }
}

#Preview {
    ContentView()
}
