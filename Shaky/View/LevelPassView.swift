//
//  LevelPassView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 8.11.2023.
//

import SwiftUI

struct LevelPassView: View {
    let completion : completionType
    let completedLevel : Int
    let paidUser : Bool = true
    var title : String { return completion == .success ? "High Five 👏" : "Oops... 🫤"}
    var subText : String { return completion == .success ? "What a success!" : "Wanna try again?"}
    var actionText : String { return completion == .success ? "Continue 👉" : "Try Again 🔄"}
    
    @State var showLevel = false
        
    var body: some View {
        
        if showLevel{
            
            if completedLevel == gameLevels.count {
                GameLevelView(gameLevel: gameLevels[completedLevel-1])
            } else{
                GameLevelView(gameLevel: gameLevels[completedLevel])

            }
            
        } else{
            
            VStack{
                fullWidthText(name: title)
                fullWidthText(name: subText)
                
                Spacer()
                
                if !paidUser {
                    Text("ADVERTISEMENT-HERE")
                    Spacer()
                    fullWidthTextButton(name: "Skip Advertisements"){
                        print("skip ads")
                    }
                } else {
                    
                    fullWidthTextButton(name: actionText){
                        print("continue")
                        triggerClickHaptic()
                        showLevel = true
                    }
                    
                    if completion == .success{
                        Text("To Level \(completedLevel + 1)")
                            .font(.system(size: 40))
                    }
                }
            }
            .padding(.all)
            .onAppear{
                Music.shared.playMainMusic(action: .pause)
                Music.shared.playLevelTransitSound(completionType: completion)
            }
            .onDisappear(perform: {
                Music.shared.playMainMusic(action: .resume)
            })
        }
    }
}


#Preview {
    
    LevelPassView(completion: .success,
                  completedLevel: 1)
}


extension LevelPassView{
    enum completionType {
        case success
        case fail
    }
}
