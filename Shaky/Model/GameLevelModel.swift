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
}

let gameLevels = [
    GameLevel(levelSteps: [1.00, 0.50, 1.00], shakingRatio: 1.00, level: 1),
    GameLevel(levelSteps: randomLevelWidths(rangeBegins: 0.75, rangeEnds: 1.00, levelCount: 10), shakingRatio: 1.00, level: 2),
    GameLevel(levelSteps: randomLevelWidths(rangeBegins: 0.65, rangeEnds: 0.90, levelCount: 15), shakingRatio: 1.10, level: 3),
    GameLevel(levelSteps: randomLevelWidths(rangeBegins: 0.55, rangeEnds: 0.80, levelCount: 10), shakingRatio: 1.15, level: 4),
    GameLevel(levelSteps: randomLevelWidths(rangeBegins: 0.45, rangeEnds: 0.70, levelCount: 18), shakingRatio: 1.25, level: 5),
    GameLevel(levelSteps: randomLevelWidths(rangeBegins: 0.35, rangeEnds: 0.70, levelCount: 18), shakingRatio: 1.25, level: 6)
]


fileprivate func randomLevelWidths(rangeBegins : Double, rangeEnds : Double, levelCount : Int) -> [Double] {
    return (0...levelCount-1).map( {_ in Double.random(in: rangeBegins...rangeEnds) })
}
