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

enum Niveau: Int {
    case xxxxx
    case facile
    case moyen
    case dur
}

var damier = [
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"]
]

var pris = [
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"],
    ["vide","vide","vide","vide","vide","vide","vide","vide","vide"]
]

struct ContentView: View {
    @EnvironmentObject var settings: Settings
    @State var pion = damier
    @State var joueur = pris
    @State private var affichage = ""
    @State private var partiesJoueur = UserDefaults.standard.integer(forKey: "partiesJoueur")
    @State private var partiesOrdi = UserDefaults.standard.integer(forKey: "partiesOrdi")
    @State private var selectionNiveau = Niveau.moyen.rawValue
    @State private var quiDemarre = false
    @State private var quiJoue =  J.vide
    @State private var nbPionJoueur = 0
    @State private var nbPionOrdi = 0
    @State private var gameIsActive = true
    
    
    let smbs = UIScreen.main.bounds.size
    
    var body: some View {
        let nbLineRaw = Int(settings.sliderValue)
        
        // MARK: - Affichage Score
        return VStack {
            Text("Tic Tac Toe")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(affichage)
                .font(.headline)
                .padding()
            HStack {
                Text("Joueur: \(partiesJoueur)")
                    .font(.headline)
                Text("Ordi: \(partiesOrdi)")
                    .font(.headline)
            }
            
            // MARK: - Affichage Damier
            VStack {
                ForEach(0..<nbLineRaw) { line in
                    HStack {
                        ForEach(0..<nbLineRaw) { raw in
                            Button(action: {
                                
                                // Si le jeux est actif, le Joueur Joue
                                if self.gameIsActive {
                                    self.Joueur(line:line, raw: raw)
                                }
                                
                                // On teste si quelqu'un a gagne
                                self.quiAGagne(nbLineRaw: nbLineRaw)

                                // Si le jeux est actif, l'ordinateur joue apres 1s
                                if self.gameIsActive {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                        self.ordinateur(nbLineRaw: nbLineRaw)
                                    })
                                }
                            
                                // On teste si quelqu'un a gagne
                                self.quiAGagne(nbLineRaw: nbLineRaw)
                            }) {
                                HStack(spacing: 12) {
                                    Image(self.pion[line][raw])
                                        .renderingMode(.original)
                                        .resizable()
                                        .padding(5)
                                        .frame(width: (self.smbs.width - 50) / CGFloat(nbLineRaw) , height: (self.smbs.width - 50) / CGFloat(nbLineRaw))
                                        .background(Color.orange)
                                }
                            }
                        }
                    }
                }
            }
            
            
            // MARK: - Parametres
            HStack {
                Toggle(isOn: $quiDemarre) {
                    Text("Joueur/Ordi")
                }
                    
                .padding()
                
                Picker(selection: $selectionNiveau, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    Text("Facile").tag(1)
                    Text("Moyen").tag(2)
                    Text("Dur").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            
            // MARK: - Qui Demarre
            HStack {
                // true si l'ordinateur demarre
                Button(action: {
                    if self.quiDemarre == true {
                        self.gameIsActive = true
                        self.ordinateur(nbLineRaw: nbLineRaw)
                    }
                }) {
                    Text("Jouer")
                    .padding(.top, 20)
                    .clipped()
                }
                
                
                Button(action: {
                    self.raz(nbLineRaw: nbLineRaw)
                }) {
                    Text("Raz")
                    .font(.body)
                    .padding(.top, 20)
                    .clipped()
                }
            }
        }
    }
    
    // MARK: - Joueur
    func Joueur(line: Int,  raw : Int) {
        quiJoue = .joueur
        if self.joueur[line][raw] == "vide" && gameIsActive {
            self.pion[line][raw] = "croix"
            self.joueur[line][raw] = "joueur"
        }
    }
    
    // MARK: - Ordinateur
    func ordinateur(nbLineRaw: Int) {
        quiJoue = .ordi
        // Joue au hazard
        while true {
            let lineR = Int.random(in: 0...nbLineRaw - 1 )
            let rawR = Int.random(in: 0...nbLineRaw - 1 )
            if self.joueur[lineR][rawR] == "vide" && gameIsActive {
                self.pion[lineR][rawR] = "rond"
                self.joueur[lineR][rawR] = "ordi"
                break
            }
        }
    }
    
    // MARK: - RAZ
    
    func raz(nbLineRaw: Int) {
        for line in 0..<nbLineRaw {
            for raw in 0..<nbLineRaw {
                pion[line][raw] = "vide"
                joueur[line][raw] = "vide"
                affichage = ""
                nbPionOrdi = 0
                nbPionJoueur = 0
                gameIsActive = true
            }
        }
    }
    
    // MARK: - Qui a gagne
    func quiAGagne(nbLineRaw: Int) {
        
        // Test des lignes
        for line in 0..<nbLineRaw {
            nbPionJoueur = 0
            nbPionOrdi = 0
            for raw in 0..<nbLineRaw {
                if joueur[line][raw] == "joueur" {
                    nbPionJoueur += 1
                    if nbPionJoueur == nbLineRaw {
                        affichage = "Le joueur a gagné"
                        gameIsActive = false
                        break
                    }
                }
                
                if joueur[line][raw] == "ordi" {
                    nbPionOrdi += 1
                    if nbPionOrdi == nbLineRaw {
                        affichage = "L'Ordi a gagné"
                        gameIsActive = false
                        break
                    }
                }
            }
        }
        
        // Test des colonnes
        for raw in 0..<nbLineRaw {
            nbPionJoueur = 0
            nbPionOrdi = 0
            for line in 0..<nbLineRaw {
                if joueur[line][raw] == "joueur" {
                    nbPionJoueur += 1
                    if nbPionJoueur == nbLineRaw {
                        affichage = "Le joueur a gagné"
                        gameIsActive = false
                        break
                    }
                }
                
                if joueur[line][raw] == "ordi" {
                    nbPionOrdi += 1
                    if nbPionOrdi == nbLineRaw {
                        affichage = "L'Ordi a gagné'"
                        gameIsActive = false
                        break
                    }
                }
            }
        }
        
        // Test diagonale droite
        nbPionJoueur = 0
        nbPionOrdi = 0
        for line in 0..<nbLineRaw {
            for raw in 0..<nbLineRaw {
                if line == 0 && raw == 0  {
                    if joueur[line][raw] == "joueur" {
                        nbPionJoueur += 1
                    }
                    
                    if joueur[line][raw] == "ordi" {
                        nbPionJoueur += 1
                    }
                }

                if line == 1 && raw == 1 {
                    if joueur[line][raw] == "joueur" {
                        nbPionJoueur += 1
                    }
                    
                    if joueur[line][raw] == "ordi" {
                        nbPionJoueur += 1
                    }
                }

                if line == 2 && raw == 2 {
                    if joueur[line][raw] == "joueur" {
                        nbPionJoueur += 1
                    }
                    
                    if joueur[line][raw] == "ordi" {
                        nbPionJoueur += 1
                    }
                }
            }

            if nbPionJoueur == nbLineRaw {
                affichage = "Le joueur a gagné"
                gameIsActive = false
                break
            }
            
            if nbPionOrdi == nbLineRaw {
                affichage = "Le joueur a gagné"
                gameIsActive = false
                break
            }
        }
        
        
        // Test diagonale gauche
        nbPionOrdi = 0
        nbPionJoueur = 0
        for line in 0..<nbLineRaw {
            for raw in 0..<nbLineRaw {
                if line == 0 && raw == 2  {
                    if joueur[line][raw] == "joueur" {
                        nbPionJoueur += 1
                    }
                }

                if line == 1 && raw == 1 {
                    if joueur[line][raw] == "joueur" {
                        nbPionJoueur += 1
                    }
                }

                if line == 2 && raw == 0 {
                    if joueur[line][raw] == "joueur" {
                        nbPionJoueur += 1
                    }
                }

                if nbPionJoueur == nbLineRaw {
                    affichage = "Le joueur a gagné"
                    gameIsActive = false
                    break
                }
            }

            if nbPionJoueur == nbLineRaw {
                affichage = "Le joueur a gagné"
                gameIsActive = false
                break
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Settings())
    }
}
