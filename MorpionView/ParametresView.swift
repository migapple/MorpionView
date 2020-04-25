//
//  ParametresView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 24/04/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var sliderValue: Float = 3.0
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
            
            Text("Nbre de cases : \(Int(settings.sliderValue))")
            
//            UserDefaults.standard.set($settings.sliderValue, forKey: "sliderValue")

        }
        
    }
    
    struct ParametresView_Previews: PreviewProvider {
        static var previews: some View {
            ParametresView().environmentObject(Settings())
        }
    }
}
