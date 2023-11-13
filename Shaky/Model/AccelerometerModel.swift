//
//  AccelerometerModel.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 5.11.2023.
//

import Foundation
import CoreMotion

class AccelerometerModel : ObservableObject {
    
    private let motion = CMMotionManager()
    private var timer : Timer?
    @Published var netAccP : Int = 0
    @Published var phoneOnYAxis = true
    
    func stopAccelerometers(){
        print("Stopping accelerometers")
        self.motion.stopAccelerometerUpdates()
        self.timer?.invalidate()
    }
    
    func startAccelerometers() {
        if self.motion.isAccelerometerAvailable {
            // 50 hz is iOS default rate, 10 hz is to slow, 2*-25 is okay, more the hz, more fluid animation
            let hz = 1.0 / 25.0
            self.motion.accelerometerUpdateInterval = hz
            self.motion.startAccelerometerUpdates()
            self.timer = Timer(fire: Date(), interval: (hz), repeats: true, block: { (timer) in
                // Get the accelerometer data.
                if let data = self.motion.accelerometerData {
                    let x2 = pow(data.acceleration.x, 2)
                    let y2 = pow(data.acceleration.y, 2)
                    let z2 = pow(data.acceleration.z, 2)
                    let netAcc2 = x2 + y2 + z2
                    let netAccP = Int(netAcc2 * 300) - 300
                    self.netAccP = netAccP
                    self.phoneOnYAxis = y2 > x2 && y2 > z2                    
                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }
}
