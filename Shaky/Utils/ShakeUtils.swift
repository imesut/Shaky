//
//  ShakeUtils.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 7.11.2023.
//

import Foundation
import UIKit

fileprivate let impactCatalog = [0.25, 0.65, 0.75, 0.85, 0.9,  1]
fileprivate let impactGenerator = UIImpactFeedbackGenerator()
fileprivate let genericGenerator = UISelectionFeedbackGenerator()

func triggerJumpHaptic(){
    impactGenerator.impactOccurred(intensity: impactCatalog.randomElement() ?? 1)
}

func triggerClickHaptic(){
    genericGenerator.selectionChanged()
}
