//
//  ParametresView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 24/04/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var sliderValue: Float = UserDefaults.standard.float(forKey: "sliderValue") {
        didSet {
            UserDefaults.standard.set(self.sliderValue, forKey: "sliderValue")
        }
    }
    
    @Published var soundActive: Bool = UserDefaults.standard.bool(forKey: "soundActive") {
        
        didSet {
            UserDefaults.standard.set(self.sliderValue, forKey: "soundActive")
        }
    }
}


struct ParametresView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack {
            
            Text("Parametrage")
                .fontWeight(.black)
            
            Spacer()
            
            Slider(value: $settings.sliderValue, in: 3...6, step: 1)
                .border(Color.green, width: 2)
                .padding()
            
            Text("Nbre de cases : \(Int(settings.sliderValue)) X \(Int(settings.sliderValue))")
            
            
            Toggle(isOn: $settings.soundActive) {
                Text(settings.soundActive ? "Sound Active" : "Sound Inactive")
            }
            .padding()
            
            Spacer()
        }
    }
    
    struct ParametresView_Previews: PreviewProvider {
        static var previews: some View {
            ParametresView().environmentObject(Settings())
        }
    }
}
