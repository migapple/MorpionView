//
//  HelpView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 03/05/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    @EnvironmentObject var settings: Settings
    @State private var showIcon = false
    
    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
        .speed(1)
        .delay(0.25)
    }
    
    var body: some View {
        VStack {
        Text("Tic-Tac-Toe")
            .font(.system(.title, design: .serif))
            .multilineTextAlignment(.center)
            
            Image("Tic-Tac-Toe")
            .offset(x: 0, y: showIcon ? 0 : 75)
            .animation(slideInAnimation)
                
            .padding()
        VStack(alignment: .leading, spacing: 10) {
            Text("Htext1")
            Text("Htext2")
            Text("Htext3")
            Text("Htext4")
            Text("Htext5")
            Text("Htext6")
        }
        .frame(width: 350, height: 400)
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [Color("OrangeLight"), Color(.orange)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(10)
        .shadow(radius: 10)
//        .onAppear(perform: {
//            if self.settings.soundActive {
//                playSound(sound: "background-music", type: "mp3")
//            }
//        })
            
            Text("© 2010  Michel Garlandat")
            .padding()
        }
        .onDisappear {
            self.showIcon.toggle()
        }
            
        .animation(slideInAnimation)
            .onAppear {
                self.showIcon.toggle()
            }
        }
    }


struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
        .previewDevice("iPhone SE")
         .environment(\.locale, .init(identifier: "en"))
    }
}
