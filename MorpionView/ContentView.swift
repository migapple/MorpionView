//
//  ContentView.swift
//  MorpionView
//
//  Created by Michel Garlandat on 23/04/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import SwiftUI


enum QuiJoue {
    case vide
    case joueur
    case ordi
}

struct Pion: Hashable {
    var aff: String
    var Jou: QuiJoue
}

enum Niveau: Int {
    case xxxxx
    case facile
    case moyen
    case dur
}

struct Dame {
    var place : String
    var couleur: Color
}

var damier = [
    [Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange)],
    [Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange)],
    [Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange)],
    [Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange)],
    [Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange)],
    [Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange),Dame(place: "vide", couleur: .orange)]
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
    //    @State private var quiJoue =  J.vide
    @State private var nbPionJoueur = 0
    @State private var nbPionOrdi = 0
    @State private var gameIsActive = true
    @State private var gameState = [QuiJoue](repeating: .vide, count: 64)
    
    let smbs = UIScreen.main.bounds.size
    
    var body: some View {
        let nbLineRaw = Int(settings.sliderValue)
        
        var winComb : [[Int]] {
            if nbLineRaw == 3  {
                return [[0,1,2],[3,4,5],[6,7,8], // Horizontal
                    [0,3,6],[1,4,7],[2,5,8], // Vertical
                    [0,4,8],[2,4,6]]         // Diagonale
            }
            
            if nbLineRaw == 4  {
                return [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15],  // Horizontal
                    [0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15],  // Vertical
                    [0,5,10,15],[3,6,9,12]                          // Diagonale
                ]
            }
            
            if nbLineRaw == 5  {
                return [[0,1,2,3,4],[5,6,7,8,9],[10,11,12,13,14],[15,16,17,18,19],[20,21,22,23,24],  // Horizontal
                    [0,5,10,15,20],[1,6,11,16,21],[2,7,12,17,22],[3,9,8,13,23],[4,9,14,19,24],    // Vertical
                    [0,6,12,18,24],[4,8,12,16,20]                                   // Diagonale
                ]
            }
            
            if nbLineRaw == 6  {
                return [[0,1,2,3,4,5],[6,7,8,9,10,11],[12,13,14,15,16,17],[18,19,20,21,22,23],[24,25,26,27,28,29],[30,31,32,33,34,35],  // Horizontal
                    [0,6,12,18,24,30],[1,7,13,19,25,31],[2,8,14,20,26,32],[3,9,15,21,27,33],[4,10,16,22,28,34], [5,11,17,23,29,35],         // Vertical
                    [0,7,14,21,28,35],[5,10,15,20,25,35]                                                                                    // Diagonale
                ]
            }
            
            return [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        }
        
        // MARK: - Affichage Score
        return VStack {
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
                                    self.Joueur(line:line, raw: raw, nbLineRaw: nbLineRaw)
                                }
                                
                                // On teste si quelqu'un a gagne
                                self.quiAGagne(line:line, raw: raw, nbLineRaw: nbLineRaw, winComb: winComb)
                                
                                // Si le jeux est actif, l'ordinateur joue apres 1s
                                if self.gameIsActive {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                        self.ordinateur(nbLineRaw: nbLineRaw)
                                        // On teste si quelqu'un a gagne
                                        self.quiAGagne(line:line, raw: raw, nbLineRaw: nbLineRaw, winComb: winComb)
                                    })
                                }
                                
                            }) {
                                HStack(spacing: 12) {
                                    if self.pion[line][raw].couleur == Color.orange {
                                    Image(self.pion[line][raw].place)
                                        .renderingMode(.original)
                                        .resizable()
                                        .padding(5)
                                        .frame(width: (self.smbs.width - 50) / CGFloat(nbLineRaw) , height: (self.smbs.width - 50) / CGFloat(nbLineRaw))
                                        .background(Color.orange)
                                    } else {
                                        Image(self.pion[line][raw].place)
                                        .renderingMode(.original)
                                        .resizable()
                                        .padding(5)
                                        .frame(width: (self.smbs.width - 50) / CGFloat(nbLineRaw) , height: (self.smbs.width - 50) / CGFloat(nbLineRaw))
                                        .background(Color.green)
                                    }
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
    func Joueur(line: Int,  raw : Int, nbLineRaw: Int) {
        if self.joueur[line][raw] == "vide" && gameIsActive {
            self.pion[line][raw].place = "croix"
            self.joueur[line][raw] = "joueur"
            gameState[twoDimOneDim(line: line, raw: raw, nbLineRaw: nbLineRaw)] = .joueur
        }
    }
    
    // MARK: - Ordinateur
    func ordinateur(nbLineRaw: Int) {
        // Joue au hazard
        while true {
            let lineR = Int.random(in: 0...nbLineRaw - 1 )
            let rawR = Int.random(in: 0...nbLineRaw - 1 )
            if self.joueur[lineR][rawR] == "vide" && gameIsActive {
                self.pion[lineR][rawR].place = "rond"
                self.joueur[lineR][rawR] = "ordi"
                gameState[twoDimOneDim(line: lineR, raw: rawR, nbLineRaw: nbLineRaw)] = .ordi
                break
            }
        }
    }
    
    // MARK: - RAZ
    
    func raz(nbLineRaw: Int) {
        // On remet à 0 les case jouées
        gameState = [QuiJoue](repeating: .vide, count: 64)
        
        self.partiesOrdi = 0
        self.partiesJoueur = 0
        
        for line in 0..<nbLineRaw {
            for raw in 0..<nbLineRaw {
                pion[line][raw].place = "vide"
                pion[line][raw].couleur = .orange
                joueur[line][raw] = "vide"
                affichage = ""
                nbPionOrdi = 0
                nbPionJoueur = 0
                gameIsActive = true
            }
        }
    }
    
    // MARK: - Qui a gagne
    func quiAGagne(line: Int, raw: Int , nbLineRaw: Int, winComb: [[Int]]) {
        
        // Cases Gagnantes
        for combination in winComb {
            var nbJoueur = 0
            var nbOrdi = 0
            
            for i in 0..<nbLineRaw {
                if self.gameState[combination[i]] == .joueur { nbJoueur += 1 }
                if self.gameState[combination[i]] == .ordi { nbOrdi += 1 }
            }
            
            if nbJoueur == nbLineRaw {
                for i in 0..<nbLineRaw {
                    let indices = twoDim(nombre: combination[i])
                    pion[indices.ind1][indices.ind2].couleur = .green
                }
                // Cross has won
                affichage = "Les croix on gagné"
                
                partiesJoueur += 1
                UserDefaults.standard.set(self.partiesJoueur, forKey: "partiesJoueur")
                gameIsActive = false
                pion[0][0].couleur = .green
                
            } else if nbOrdi == nbLineRaw {
                for i in 0..<nbLineRaw {
                    let indices = twoDim(nombre: combination[i])
                    print(indices)
                    pion[indices.ind1][indices.ind2].couleur = .green
                }
                // Nought has won
                affichage = "Les ronds on gagné"
                partiesOrdi += 1
                UserDefaults.standard.set(self.partiesOrdi, forKey: "partiesOrdi")
                gameIsActive = false
            }
        }
        
        // Si toutes les case sont jouées
        if gameIsActive {
            var caseLibre = false
            for line in 0..<nbLineRaw {
                for raw in 0..<nbLineRaw {
                    if pion[line][raw].place == "vide" {
                        caseLibre = true
                        break
                    }
                }
            }
            
            if caseLibre == false {
                affichage = "Plus de combinaisons"
                //                buttonHidden = false
            }
        }
    }
    
    func twoDimOneDim(line: Int, raw: Int, nbLineRaw: Int) -> Int {
        let value = line * nbLineRaw + raw
        return value
    }
    
    // MARK: - Converti une dimension en 2 dimentions
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
