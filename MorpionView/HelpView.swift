//
//  HelpView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 03/05/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            Text("Aide")
        }
        .onAppear(perform: {
            playSound(sound: "background-music", type: "mp")
        })
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
