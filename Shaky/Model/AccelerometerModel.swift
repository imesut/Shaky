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
//    @Published var diffNetAcc : Int = 0
    
    func stopAccelerometers(){
        print("Stopping accelerometers")
        self.motion.stopAccelerometerUpdates()
        self.timer?.invalidate()
    }
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            // 50 hz is iOS default rate, 10 hz is to slow, 2*-25 is okay, more the hz, more fluid animation
            let hz = 1.0 / 25.0
            self.motion.accelerometerUpdateInterval = hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (hz), repeats: true, block: { (timer) in
                // Get the accelerometer data.
                if let data = self.motion.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    
                    let netAcc2 = (x*x + y*y + z*z)
                    let netAccP = Int(netAcc2 * 300) - 300
//                    self.diffNetAcc = abs(self.netAccP - netAccP)
                    
                    self.netAccP = netAccP
//                    print(self.diffNetAcc)
                }
            })
            
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }
    
}
