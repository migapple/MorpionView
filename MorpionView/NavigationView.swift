//
//  NavigationView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 24/04/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI

struct NavigationView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack {
            
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("jeux")
                }
                
                ParametresView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("parametrage")
                }
                
                HelpView()
                    .tabItem {
                        Image(systemName: "questionmark.circle")
                        Text("aide")
                }
                .onAppear {
                    playSound(sound: "background-music", type: "mp3")
                }
                .onDisappear {
                    audioPlayer?.stop()
                }
            }
            .accentColor(.orange)
                
                
            .onAppear {
                guard let Retreive1 = UserDefaults.standard.value(forKey: "sliderValue") else { return }
                self.settings.sliderValue = Float(Retreive1 as! CGFloat)
                
//                guard let Retreive2 = UserDefaults.standard.value(forKey: "soundActive") else { return }
//                self.settings.soundActive = Bool(Retreive2 as! Bool)
            }
                
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView().environmentObject(Settings())
        .previewDevice("iPhone SE")
        .environment(\.locale, .init(identifier: "en"))
    }
}
