//
//  VibrationService.swift
//  toDO
//
//  Created by Mercury on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

import AudioToolbox


class VibrationService: NSObject {
    
    static let shared = VibrationService()
    private override init() {}
    
    private var vibrateCount = 0
    private var vibrateTimer: Timer!
    
    func startVibrate(times: Int) {
        playVibrate() // 初回再生
        vibrateCount = times
        vibrateTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(VibrationService.timerUpdate), userInfo: nil, repeats: true)
    }
    
    func stopVibrate() {
        vibrateTimer.invalidate()
    }
    
    @objc private func timerUpdate() {
        vibrateCount -= 1
        if vibrateCount > 0 {
            playVibrate()
        } else {
            vibrateTimer.invalidate()
        }
    }
    
    private func playVibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
