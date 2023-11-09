//
//  GameLevelView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 5.11.2023.
//

import SwiftUI

struct GameLevelView: View {
    
    private let levelNumber : Int
    @State private var shouldGameFail = false
    
    // Model
    @StateObject private var accModel = AccelerometerModel()
    
    // Level Logics and States
    var levelSteps : [Double] = [0.55, 0.5, 0.45, 0.4, 0.4, 0.4, 0.4, 0.3, 0.3, 0.4]
    private var totalMovementCount : Int {return self.levelSteps.count}
    
    @State private var tickCount = 0
    var wayDown = true
    var shakingRatio : CGFloat = 0.8
    
    // Animation Variables
    @State private var ballPositionAnimationUnit = CGPoint(x: 1000, y: -100)
    @State private var barAnimationUnit : Double = 2
    @State private var ballRotateAnimationUnit : Double = 0
    private let ballSize : CGFloat = 50.0
    
    init(gameLevel : GameLevel) {
        self.levelSteps = gameLevel.levelSteps
        self.wayDown = gameLevel.wayDown
        self.shakingRatio = gameLevel.shakingRatio
        self.levelNumber = gameLevel.level
    }
    
    var body: some View {
        
        // Level Pass - Fail View
        if shouldGameFail == true {
            LevelPassView(completion: .fail, completedLevel: levelNumber - 1)
            
        } else{
            
            // Level Pass - Sucess View
            if tickCount == totalMovementCount {
                LevelPassView(completion: .success, completedLevel: levelNumber)
            } else{
                
                //MARK: Main Level View
                
                GeometryReader(content: { geometry in
                    VStack{
                        // Header Area
                        VStack{
                            Text("LEVEL: \(levelNumber)\nJump: \(tickCount) / " + String(totalMovementCount))
                                .font(.caption).multilineTextAlignment(.center)
                            Spacer()
                        }.frame(height: geometry.size.height/10)
                        
                        // Ball and Walls
                        ZStack{
                            Color.primary
                            
                            rowBgView(geometry: geometry)
                            
                            // Ball
                            Image(systemName: "volleyball.fill").resizable().scaledToFit()
                                .frame(width: ballSize, height: ballSize)
                                .rotationEffect(.degrees(ballRotateAnimationUnit), anchor: .center)
                                .position(ballPositionAnimationUnit)
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
                            RoundedRectangle(cornerSize: CGSize(width: 50, height: 50), style: .continuous)
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
                            HStack(spacing: 0){
                                Spacer()
                                Image(systemName: "tennis.racket").resizable().scaledToFit()
                                    .animation(.bouncy, value: tickCount)
                                
                                orangeUnderline(
                                    body: Text("JUMP")
                                    .font(.system(size: geometry.size.height/10 - 10))
                                )
                                Spacer()
                            }
                            .foregroundColor(.primary)
                        }
                        .frame(height: geometry.size.height/10 - 10)
                    }
                    .onChange(of: $accModel.netAccP.wrappedValue | tickCount) { _ in
                        pointerPosition(geometry: geometry)
                    }
                })
                .onAppear{
                    accModel.startAccelerometers()
                }
                .onDisappear{
                    accModel.stopAccelerometers()
                }
            }
        }
    }
}

#Preview {
    GameLevelView(gameLevel: gameLevels.first!)
}



// Logic Extensions
extension GameLevelView {
    
    func jump(){
        tickCount = wayDown ? tickCount + 1 : tickCount - 1
        triggerJumpHaptic()
    }
    
    
    // Calculates Ball Position
    func pointerPosition(geometry : GeometryProxy) {
        let center = geometry.size.width / 2
//        let widthOfThePointer = geometry.size.height / CGFloat(totalMovementCount)
        let xPosition = center + CGFloat($accModel.netAccP.wrappedValue) * shakingRatio
        
        let rowHeight = geometry.size.height * 0.8 / CGFloat(totalMovementCount + 1)
        let yPosition = CGFloat(tickCount) * rowHeight
        
        let ballAnimationUnit = CGPoint(x: xPosition, y: yPosition)
        self.ballPositionAnimationUnit = ballAnimationUnit
        
        // MARK: - Level Fail Logic
        //TODO: why sometimes tickCount exceed?
        let t = tickCount < totalMovementCount ? tickCount : totalMovementCount
        let currentStepsWidth = levelSteps[t] * geometry.size.width
        let displacement = abs(xPosition - center) * 2/* + ballSize / 3*/
        if displacement > currentStepsWidth {
            shouldGameFail = true
        }
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
