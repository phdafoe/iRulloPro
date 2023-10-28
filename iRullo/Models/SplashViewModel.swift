//
//  SplashViewModel.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 28/10/23.
//

import Foundation

final class SplashViewModel: ObservableObject {
    
    var timerSplash = Timer()
    var durationTimer = 3
    
    @Published var canNavigate = false
    
    init(){
        durationTimer = 3
        startSplashTimer()
    }
    
    func startSplashTimer(){
        timerSplash = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSplashTimer), userInfo: nil, repeats: true)
    }
    
    func stopSplashTimer() {
        timerSplash.invalidate()
    }
    
    @objc
    func updateSplashTimer() {
        if(durationTimer > 0) {
            durationTimer -= 1
        } else {
            stopSplashTimer()
            durationTimer = 3
            self.canNavigate = true
        }
    }
    
}
