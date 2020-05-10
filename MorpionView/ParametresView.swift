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
            UserDefaults.standard.set(self.soundActive, forKey: "soundActive")
        }
    }
}


struct ParametresView: View {
    @EnvironmentObject var settings: Settings
    
    let smbs = UIScreen.main.bounds.size
    
    var body: some View {
        ZStack {
//            frame(width: smbs.width, height: smbs.height)
            VStack {
                
                Text("parametrage")
                    .fontWeight(.black)
                    .font(.system(.title, design: .rounded))
                    .padding()
                
                Spacer()
                
                Slider(value: $settings.sliderValue, in: 3...6, step: 1)
                    .border(Color.green, width: 2)
                    .padding()
                
                Text("nbre de cases : \(Int(settings.sliderValue)) X \(Int(settings.sliderValue))")
                
                
                Toggle(isOn: $settings.soundActive) {
                    Text(settings.soundActive ? "sons Actifs" : "sons Inactifs")
                }
                .padding()
                
                Spacer()
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("OrangeLight"), Color(.orange)]), startPoint: .top, endPoint: .bottom))
    }
    
    struct ParametresView_Previews: PreviewProvider {
        static var previews: some View {
            ParametresView().environmentObject(Settings())
             .environment(\.locale, .init(identifier: "en"))
        }
    }
}
