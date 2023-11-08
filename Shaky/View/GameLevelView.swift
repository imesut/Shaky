//
//  GameLevelView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 5.11.2023.
//

import SwiftUI

struct GameLevelView: View {
    // Model
    @Binding var acceleration : Int
    
    // Level Logics and States
    var levelSteps : [Double] = [0.55, 0.5, 0.45, 0.4, 0.4, 0.4, 0.4, 0.3, 0.3, 0.4]
    @State var tickCount = 0
    var totalMovementCount = 20
    @State var wayDown = true
    
    // Animation Variables
    @State var ballPositionAnimationUnit = CGPoint(x: 0, y: 0)
    @State var barAnimationUnit : Double = 2
    @State var ballRotateAnimationUnit : Double = 0
    
    
    var body: some View {
        
        if tickCount == totalMovementCount {
            
            LevelPassView(completion: .success, completedLevel: 1)
            
        } else{
            
            GeometryReader(content: { geometry in
                VStack{
                    // Header Area
                    VStack{
                        Text("LEVEL: 1\nJump: \(tickCount) / " + String(totalMovementCount))
                            .font(.caption).multilineTextAlignment(.center)
                        Spacer()
                    }.frame(height: geometry.size.height/10)
                    
                    // Ball and Walls
                    ZStack{
                        Color.primary
                        
                        rowBgView(geometry: geometry)
                        
                        // Ball
                        Image(systemName: "volleyball.fill").resizable().scaledToFit()
                            .frame(width: 50, height: 50)
                            .rotationEffect(.degrees(ballRotateAnimationUnit), anchor: .center)
                            .position(pointerPosition(geometry: geometry))
                            .animation(.linear, value: ballPositionAnimationUnit)
                            .onAppear{
                                withAnimation(.linear.speed(0.04).repeatForever(autoreverses: false)){
                                    ballRotateAnimationUnit = 360
                                }
                            }
                    }
                    
                    // Animated Bar
                    Group{
                        Spacer()
                        RoundedRectangle(cornerSize: CGSize(width: barAnimationUnit, height: barAnimationUnit), style: .continuous)
                            .foregroundColor(Color.primary)
                            .frame(height: barAnimationUnit)
                            .padding(.horizontal, barAnimationUnit * 12)
                            .onAppear{
                                withAnimation(.easeInOut.speed(0.25).repeatForever()){
                                    barAnimationUnit = 6
                                }
                            }
                    }.frame(height: 12)
                    
                    Button {
                        jump()
                    } label: {
                        HStack{
                            Image(systemName: "tennis.racket").resizable().scaledToFit()
                                .animation(.bouncy, value: tickCount)
                            Text("JUMP")
                                .font(.system(size: geometry.size.height/10 - 10))
                        }
                        .foregroundColor(.primary)
                    }
                    .frame(height: geometry.size.height/10 - 10)
                }
            })
            
        }
    }
}

#Preview {
    let cv = ContentView()
    return GameLevelView(/*showLevel: cv.$displayGameLevel,*/ acceleration: cv.$accModel.netAccP)
}



// Logic Extensions
extension GameLevelView {
    
    func jump(){
        tickCount = wayDown ? tickCount + 1 : tickCount - 1
//        if tickCount == totalMovementCount{
//            tickCount = 0
//        }
        triggerJumpHaptic()
    }
    
    
    
    // Calculates Ball Position
    func pointerPosition(geometry : GeometryProxy) -> CGPoint {
        let center = geometry.size.width / 2
        let widthOfThePointer = geometry.size.height / CGFloat(self.totalMovementCount)
        let xPosition = center - widthOfThePointer / 2 - CGFloat(self.$acceleration.wrappedValue * 3)
        
        let rowHeight = geometry.size.height * 0.8 / CGFloat(self.totalMovementCount + 1)
        let yPosition = CGFloat(self.tickCount) * rowHeight
        
        let ballAnimationUnit = CGPoint(x: xPosition, y: yPosition)
        self.ballPositionAnimationUnit = ballAnimationUnit
        
        return ballAnimationUnit
    }
    
}



// View Extensions
extension GameLevelView {
    
    // Creating Wall Steps
    private func rowBgView(geometry : GeometryProxy) -> some View{
        return VStack(alignment: .center, spacing: 0){
            ForEach(self.levelSteps, id: \.self) { widthAsRatio in
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .frame(width: geometry.size.width * widthAsRatio)
                // To support both dark and light mode, inverting the primary color
                    .background(Color.primary.colorInvert())
            }
        }
    }
    
    
}
