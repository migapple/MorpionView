//
//  ParametresView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 24/04/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI

//var slideInAnimation: Animation {
//       Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
//       .speed(1)
//       .delay(0.25)
//}
//
//class Settings: ObservableObject {
//    @Published var sliderValue: Float = UserDefaults.standard.float(forKey: "sliderValue") {
//        didSet {
//            UserDefaults.standard.set(self.sliderValue, forKey: "sliderValue")
//        }
//    }
//    
//    @Published var soundActive: Bool = UserDefaults.standard.bool(forKey: "soundActive") {
//        
//        didSet {
//            UserDefaults.standard.set(self.soundActive, forKey: "soundActive")
//        }
//    }
//}


struct ParametresView: View {
    @EnvironmentObject var settings: Settings
     @State private var showIcon = false
    
    let smbs = UIScreen.main.bounds.size
    
    var body: some View {
        VStack {
            Text("Tic-Tac-Toe")
                .font(.system(.title, design: .serif))
                .multilineTextAlignment(.center)
            
                
                Image("Tic-Tac-Toe")
                .offset(x: 0, y: showIcon ? 0 : 75)
                .animation(slideInAnimation)
                    
                .padding()
                
            VStack {
                Text("parametrage")
                    .fontWeight(.black)
                    .font(.system(.title, design: .rounded))
                    .padding()
                
                Spacer()
                
                Slider(value: $settings.sliderValue, in: 3...6, step: 1)
                    .border(Color.green, width: 2)
                    .padding()
                
                Text("nbre de cases \(Int(settings.sliderValue)) X \(Int(settings.sliderValue))")
//                Text("nbre de cases \(Int(settings.sliderValue))")
                
                Toggle(isOn: $settings.soundActive) {
                    Text(settings.soundActive ? "sons Actifs" : "sons Inactifs")
                }
                .padding()
                
                Spacer()
            }
            .frame(width: 350, height: 400)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("OrangeLight"), Color(.orange)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(10)
            .shadow(radius: 10)
            
            .onDisappear {
                self.showIcon.toggle()
            }
                
            .animation(slideInAnimation)
                .onAppear {
                    self.showIcon.toggle()
                }
            }
        }
    }
    
    struct ParametresView_Previews: PreviewProvider {
        static var previews: some View {
            ParametresView().environmentObject(Settings())
             .environment(\.locale, .init(identifier: "en"))
        }
    }

