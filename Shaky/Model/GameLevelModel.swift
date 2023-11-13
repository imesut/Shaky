//
//  GameLevelModel.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 8.11.2023.
//

import Foundation

struct GameLevel{
    let levelSteps : [Double]
    let wayDown = true
    let shakingRatio : CGFloat
    let level : Int
    var nextlevel : Int {return level + 1}
}

func getLevelData(level : Int) -> GameLevel {
    
    print("equallyDistributedValues", equallyDistributedValues(start: 40, stop: 290, count: 10))
    let maxPossibleWidth = 0.98
    //                          1,  2,   3,   4,   5,   6,   7,   8,   9,  10
    let desiredDiffulties = [
        equallyDistributedValues(start: 40, stop: 290, count: 10),
        equallyDistributedValues(start: 70, stop: 330, count: 10),
        equallyDistributedValues(start: 90, stop: 350, count: 10),
        equallyDistributedValues(start: 110, stop: 290, count: 10),
        equallyDistributedValues(start: 130, stop: 290, count: 10),
        equallyDistributedValues(start: 150, stop: 350, count: 10),
        equallyDistributedValues(start: 170, stop: 330, count: 10),
        equallyDistributedValues(start: 190, stop: 350, count: 10),
        equallyDistributedValues(start: 210, stop: 370, count: 10),
        equallyDistributedValues(start: 230, stop: 330, count: 10)
    ].flatMap { $0 }
    
    let desiredDifficulty = Double(desiredDiffulties[(level - 1) % 100])
    let levelCount = (level - 1) % 5 * 3 + 3
    let minWidth = [0.90, 0.80, 0.70, 0.60, 0.55, 0.50, 0.45, 0.40, 0.47, 0.53][level % 10]
    let maxWidth = [
        minWidth,
        maxPossibleWidth,
        minWidth + 0.30 < 1.00 ? minWidth + 0.30 : maxPossibleWidth,
        minWidth + 0.20 < 1.00 ? minWidth + 0.20 : maxPossibleWidth,
        minWidth + 0.10 < 1.00 ? minWidth + 0.10 : maxPossibleWidth
    ].randomElement()!
    
    // Splitted for better Compiler check time
    var totalDifficulty : Double = 10.0 * Double(levelCount) / 15.0 // 0-10 points
    totalDifficulty += 40 / minWidth //40-100 points
    
    let shaking = min(desiredDifficulty / totalDifficulty, 2.99)
    
    let stepWidths = randomLevelWidths(rangeBegins: minWidth, rangeEnds: maxWidth, levelCount: levelCount)
    
    print("end difficulty \(Int(totalDifficulty*shaking))",
          "difficulty/woShake \(Int(totalDifficulty))",
          "min \(Int(minWidth*100))",
          "max \(Int(maxWidth*100))",
          "shake \(shaking)")
    
    return GameLevel(levelSteps: stepWidths,
                     shakingRatio: shaking,
                     level: level)
}

fileprivate func randomLevelWidths(rangeBegins : Double, rangeEnds : Double, levelCount : Int) -> [Double] {
    return (0...levelCount-1).map( {_ in Double.random(in: rangeBegins...rangeEnds) })
}


fileprivate func equallyDistributedValues(start : Int, stop : Int, count : Int) -> [Int]{
    let dif = stop - start
    let step = Int(dif / (count - 1))
    var iteration = 1
    var arr = [start]
    
    while iteration < count {
        arr.append(start + step * iteration)
        iteration += 1
    }
    
    return arr
}
