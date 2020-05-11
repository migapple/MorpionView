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
            }
            .accentColor(.orange)
                
            .onAppear {
                if let retreive1 = UserDefaults.standard.value(forKey: "sliderValue") {
                    self.settings.sliderValue = Float(retreive1 as! CGFloat)
                } else {
                    self.settings.sliderValue = 3
                }
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
