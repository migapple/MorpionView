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
    
    var body: some View {
        VStack {
            Text("Aide")
        }
        .onAppear(perform: {
            if self.settings.soundActive {
            playSound(sound: "background-music", type: "mp3")
            }
        })
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
