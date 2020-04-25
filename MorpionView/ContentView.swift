//
//  ContentView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 23/04/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI


enum J: Int {
    case vide
    case joueur
    case ordi
}

struct Pion: Hashable {
    var aff: String
    var Jou: J
}

var  damier: [[Pion]] = [
    [Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide)],
    [Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide)],
    [Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide)],
    [Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide)],
    [Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide)],
    [Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide),Pion(aff: "rien", Jou: J.vide)],
]

struct ContentView: View {
    //    var nbColRow = 6
    @EnvironmentObject var settings: Settings
    @State private var pion = damier
    
    let smbs = UIScreen.main.bounds.size
    
    var body: some View {
        let nb = Int(settings.sliderValue)
        
        return VStack {
            ForEach(0..<nb) { lign in
                HStack {
                    ForEach(0..<nb) { col in
                        Button(action: {
                            self.traiteBouton(lign:lign, col: col)
                            //                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: self.ordinateur)
                        }) {
                            HStack(spacing: 12) {
                                Image(self.pion[lign][col].aff)
                                    .renderingMode(.original)
                                    .resizable()
                                    .padding(5)
                                    .frame(width: (self.smbs.width - 50) / CGFloat(nb) , height: (self.smbs.width - 50) / CGFloat(nb))
                                    .background(Color.orange)
                            }
                        }
                    }
                }
            }
        }
        
        // MARK: - TraiteBouton
    }
    func traiteBouton(lign: Int,  col : Int) {
        self.pion[lign][col].aff = "croix"
    }
    
    // MARK: - Calcul de la dimension des cases
    func caseWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - 4 * 12)  / 3
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Settings())
    }
}
