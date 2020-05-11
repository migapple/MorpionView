//
//  Data.swift
//  MorpionView
//
//  Created by Michel Garlandat on 11/05/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI

var slideInAnimation: Animation {
       Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
       .speed(1)
       .delay(0.25)
}

class Settings: ObservableObject {
    @Published var sliderValue: Float = UserDefaults.standard.float(forKey: "sliderValue") {
        didSet {
            UserDefaults.standard.set(self.sliderValue, forKey: "sliderValue")
        }
    }
    
    @Published var soundActive: Bool = UserDefaults.standard.bool(forKey: "soundActive") {
        
        didSet {
            UserDefaults.standard.set(self.soundActive, forKey: "soundActive")
        }
    }
}
