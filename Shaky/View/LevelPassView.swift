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
    let paidUser : Bool = false
    var title : String { return completion == .success ? "High Five 👏" : "Oops... 🫤"}
    var subText : String { return completion == .success ? "What a success!" : "Wanna try again?"}
    var actionText : String { return completion == .success ? "Continue 👉" : "Try Again 🔄"}
    
    var body: some View {
        
        VStack{
            fullWidthText(name: title)
            fullWidthText(name: subText)
                
            Spacer()
            
            if !paidUser {
                Text("ADVERTISEMENT-HERE")
                Spacer()
                fullWidthTextWAction(name: "Skip Advertisements"){
                    print("skip ads")
                }
            }
            
            fullWidthTextWAction(name: actionText){
                print("continue")
                triggerClickHaptic()
            }
            
            Text("To Level \(completion == .success ? completedLevel+1 : completedLevel)")
                .font(.system(size: 40))
           
        }
        .padding(.all)
    }
}

#Preview {
    
    LevelPassView(completion: .success, completedLevel: 1)
}


extension LevelPassView{
    enum completionType {
        case success
        case fail
    }
}
