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
            Text("TIC-TAC-TOE")
                .font(.largeTitle)
                .bold()
            
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Jeux")
                }
                
                ParametresView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Paramétrage")
                }
            }
            .onAppear {
                guard let Retreive1 = UserDefaults.standard.value(forKey: "sliderValue") else { return }
                self.settings.sliderValue = Float(Retreive1 as! CGFloat)
            }
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView().environmentObject(Settings())
    }
}
