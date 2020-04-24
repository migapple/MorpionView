//
//  ContentView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 23/04/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI


enum Joueur: Int {
    case personne
    case joueur
    case ordi
}

struct Pion: Hashable {
    var indice: Int
    var affichage: String
    var joueur: Joueur
}

var  damier: [[Pion]] = [
    [Pion(indice: 0, affichage: "rien", joueur: .personne), Pion(indice: 1, affichage: "rien", joueur: .personne), Pion(indice: 2, affichage: "rien", joueur: .personne)],
    [Pion(indice: 3, affichage: "rond", joueur: .personne), Pion(indice: 4, affichage: "rien", joueur: .personne), Pion(indice: 5, affichage: "rien", joueur: .personne)],
    [Pion(indice: 6, affichage: "rien", joueur: .personne), Pion(indice: 7, affichage: "rien", joueur: .personne), Pion(indice: 8, affichage: "croix", joueur: .personne)]
]

struct ContentView: View {
    var nbColRow = 6
    @EnvironmentObject var settings: Settings
//    @State private var affichePion = Array(repeating: "Vide", count: 9)
    @State private var affichePion = [["rien","rond","croix","rond","vide","vide","vide","vide","vide"],
         ["rond","rond","croix","rond","vide","vide","vide","vide","vide"],
         ["croix","rond","croix","rond","vide","vide","vide","vide","vide"],
         ["rond","rond","croix","rond","vide","vide","vide","vide","vide"],
         ["rond","rond","croix","rond","vide","vide","vide","vide","vide"],
         ["rond","rond","croix","rond","vide","vide","vide","vide","vide"],
         ["rond","rond","croix","rond","vide","vide","vide","vide","vide"],
         ["rond","rond","croix","rond","vide","vide","vide","vide","vide"],["rond","rond","croix","vide","vide","vide","vide","vide","vide"]
        ]
    
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
                        Image(self.affichePion[lign][col])
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: (self.smbs.width - 50) / CGFloat(nb) , height: (self.smbs.width - 50) / CGFloat(nb))
                            .background(Color.orange)
//                            .onTapGesture {
//                                print(col, lign)
//                        }
                    }
                }
            }
        }
        
//        let nb = Int(settings.sliderValue)
        
//        VStack {
//            ForEach(damier, id: \.self) { row in
//                HStack {
//                    ForEach(row, id: \.self) { button in
//                        Button(action: {
//                            self.traiteBouton(button.indice)
////                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: self.ordinateur)
//                        }) {
//
//                            HStack(spacing: 12) {
//                                Image(self.affichePion[button.indice])
//                                    .renderingMode(.original)
//                                    .resizable()
//                                    .padding()
//                                    .frame(width: self.caseWidth(), height: self.caseWidth())
//                                    .background(Color.orange)
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    }
        func traiteBouton(lign: Int,  col : Int) {
//        self.affichePion[bouton] = "Croix"
    }
        
        // MARK: - Calcul de la dimension des cases
        func caseWidth() -> CGFloat {
            return (UIScreen.main.bounds.width - 4 * 12)  / 3
        }
    
    // MARK: - Converti une dimension en 3 dimentions
    func twoDim(nombre: Int) -> (ind1:Int, ind2:Int) {
        var ind1 = 0
        var ind2 = 0
        if nombre < 3 {
            ind1 = 0
            ind2 = nombre
        } else if nombre < 6 {
            ind1 = 1
            ind2 = nombre - 3
        } else if nombre < 9 {
            ind1 = 2
            ind2 = nombre - 6
        }
        
        return (ind1, ind2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Settings())
    }
}
