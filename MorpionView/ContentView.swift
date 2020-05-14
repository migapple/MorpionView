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
    var geoHeight: CGFloat
    var geoWidth: CGFloat
    @State var pion = damier
    @State var joueur = pris
    @State private var affichage = ""
    @State private var partiesJoueur = UserDefaults.standard.integer(forKey: "partiesJoueur")
    @State private var partiesOrdi = UserDefaults.standard.integer(forKey: "partiesOrdi")
    @State private var selectionNiveau = Niveau.moyen.rawValue
    @State private var quiDemarre1 = false
    @State private var quiJoue =  false
    @State private var nbPionJoueur = 0
    @State private var nbPionOrdi = 0
    @State private var gameIsActive = true
    @State private var gameState = [QuiJoue](repeating: .vide, count: 64)
    @State var hidePlayButton = false
    @State private var showIcon = false
    
    let smbs = UIScreen.main.bounds.size
    
    var body: some View {
        
        let nbLineRaw = Int(settings.sliderValue)
        
        // On modifie qui joue en fonction de qui demarre
        let quiDemarre = Binding<Bool>(get: {self.quiDemarre1}, set: {self.quiDemarre1 = $0; self.quiJoue = $0 })
        
        // Combinaisons Gagnantes
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
//            .padding()
            Text("Tic Tac Toe")
                .font(.headline)
            Text(affichage)
                .font(.headline)
            
            HStack {
                Text("joueur \(partiesJoueur)")
                    .font(.headline)
                Text("ordi \(partiesOrdi)")
                    .font(.headline)
            }
            
            // MARK: - Affichage Damier et boucle de départ
            VStack {
                ForEach(0..<nbLineRaw) { line in
                    HStack {
                        ForEach(0..<nbLineRaw) { raw in
                            Button(action: {
                                // On teste si quelqu'un a gagne
                                    self.quiAGagne(line:line, raw: raw, nbLineRaw: nbLineRaw, winComb: winComb)

                                // Si le jeux est actif, le Joueur Joue
                                if self.gameIsActive && self.quiJoue == false {
                                    self.joueurJoue(line:line, raw: raw, nbLineRaw: nbLineRaw)

                                    // On teste si quelqu'un a gagne
                                    self.quiAGagne(line:line, raw: raw, nbLineRaw: nbLineRaw, winComb: winComb)

                                    if self.gameIsActive {
                                        self.quiJoue = true
                                    }
                                }

                                // Si le jeux est actif, l'ordinateur joue apres 1s
                                if self.gameIsActive && self.quiJoue == true {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                        var trouve = false

                                        if self.selectionNiveau == 3  || self.selectionNiveau == 2 {
                                            trouve = self.chercheCombinaison(joueur: 0, winComb: winComb, nbLineRaw: nbLineRaw)
                                        }

                                        if self.selectionNiveau == 2 {
                                            if !trouve {
                                                trouve = self.chercheCombinaison(joueur: 1, winComb: winComb, nbLineRaw: nbLineRaw)
                                            }
                                        }

                                        if !trouve {
                                            self.ordinateurJoueHasard(nbLineRaw: nbLineRaw)
                                        }

                                        // On teste si quelqu'un a gagne
                                        self.quiAGagne(line:line, raw: raw, nbLineRaw: nbLineRaw, winComb: winComb)

                                        if self.gameIsActive {
                                            self.quiJoue = false
                                        }
                                    })
                                }
                            }) {
                                // On dessine les pions
                                HStack(spacing: 12) {
                                    if self.pion[line][raw].couleur == Color.orange {
                                        if self.showIcon {
                                    Image(self.pion[line][raw].place)
                                        .renderingMode(.original)
                                        .resizable()
                                        .padding(5)
                                        .frame(width: (self.geoWidth - 80) / CGFloat(nbLineRaw) , height: (self.geoHeight - 320) / CGFloat(nbLineRaw))
                                        .background(Color.orange)
                                        }
                                    } else {
                                        Image(self.pion[line][raw].place)
                                        .renderingMode(.original)
                                        .resizable()
                                        .padding(5)
                                        .frame(width: (self.geoWidth - 80) / CGFloat(nbLineRaw) , height: (self.geoHeight - 320) / CGFloat(nbLineRaw))
                                        .background(Color.green)
                                    }
                                }
                                .frame(maxWidth: 640)
                            }
                        }
                    }
                }
            }
                
            .onAppear {
                withAnimation {
                    self.showIcon.toggle()
                }
            }
                
            .onDisappear {
                self.raz(nbLineRaw: nbLineRaw, compteurs: true)
                self.showIcon.toggle()
            }
            
            .overlay(
                    VStack {
                    Image("Tic-Tac-Toe")
                        .offset(x: -135, y: showIcon ? -80 : -400)
                        .animation(slideInAnimation)
                        Spacer()
                    }
            )
            
            // MARK: - Parametres
            HStack {
                Toggle(isOn: quiDemarre) {
                    Text(quiDemarre.wrappedValue ? "ordinateur \n commence" : "joueur \n commence")
                        .font(.system(size: 16))
                        .foregroundColor(Color.orange)
                }
                .padding()
                
                Picker(selection: $selectionNiveau, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    Text("Facile").tag(1)
                    Text("Moyen").tag(2)
                    Text("Dur").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(Color.orange)
                .padding()
            }
            
            if gameIsActive {
                if quiJoue == true {
                    Image(systemName: "desktopcomputer")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.orange)
                }  else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.orange)
                }
            }
            
            // MARK: - Jouer
            HStack {
                // true si l'ordinateur demarre
                    Button(action: {
                        // On efface les cases
                        self.raz(nbLineRaw: nbLineRaw, compteurs: false)

                        // Ordinateur
                        if self.quiDemarre1 == true {
                            self.gameIsActive = true
                            self.ordinateurJoueHasard(nbLineRaw: nbLineRaw)
                            self.quiJoue = false

                        } else {
                            self.quiJoue = false
                            self.gameIsActive = true
                        }

                        self.hidePlayButton = true

                    }) {
                        if !self.hidePlayButton {
                        Text("Jouer")
                            .font(.headline)
                            .frame(width: UIScreen.main.bounds.width/5, height: 20)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                        }
                    }

                Button(action: {
                    self.raz(nbLineRaw: nbLineRaw, compteurs: true)
                    self.hidePlayButton = false
                }) {
                    Text("Raz")
                        .frame(width: UIScreen.main.bounds.width/5, height: 20)
                        .foregroundColor(.orange)
                        .font(.headline)
                        .padding()
                        .border(Color.orange, width: 5)
                        .cornerRadius(5)
                }
            }
            .padding(.bottom, 20)
        }
//        .environment(\.horizontalSizeClass, .compact)
    }
    
    // MARK: - Joueur
    func joueurJoue(line: Int,  raw : Int, nbLineRaw: Int) {
        if self.joueur[line][raw] == "vide" && gameIsActive {
            self.pion[line][raw].place = "croix"
            self.joueur[line][raw] = "joueur"
            gameState[twoDimOneDim(line: line, raw: raw, nbLineRaw: nbLineRaw)] = .joueur
//            quiJoue = true
        }
    }
    
    // MARK: - Joueur
    func OrdinateurJoue(line: Int,  raw : Int, nbLineRaw: Int) {
        if self.joueur[line][raw] == "vide" && gameIsActive {
            self.pion[line][raw].place = "rond"
            self.joueur[line][raw] = "ordi"
            gameState[twoDimOneDim(line: line, raw: raw, nbLineRaw: nbLineRaw)] = .ordi
//            quiJoue = false
        }
    }
    
    // MARK: - Ordinateur joue au Hasard
    func ordinateurJoueHasard(nbLineRaw: Int) {
        // Joue au hazard
        while true {
            let lineR = Int.random(in: 0...nbLineRaw - 1 )
            let rawR = Int.random(in: 0...nbLineRaw - 1 )
            if self.joueur[lineR][rawR] == "vide" && gameIsActive {
                self.pion[lineR][rawR].place = "rond"
                self.joueur[lineR][rawR] = "ordi"
                gameState[twoDimOneDim(line: lineR, raw: rawR, nbLineRaw: nbLineRaw)] = .ordi
//                quiJoue = false
                break
            }
        }
    }
    
    // MARK: - RAZ
    func raz(nbLineRaw: Int, compteurs: Bool) {
        // On remet à 0 les case jouées
        gameState = [QuiJoue](repeating: .vide, count: 64)
        
        if compteurs {
            self.partiesOrdi = 0
            self.partiesJoueur = 0
        }
        
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
                // On affiche les cases en vert
                for i in 0..<nbLineRaw {
                    let indices = twoDim(nombre: combination[i], nbLineRaw: nbLineRaw)
                    pion[indices.ind1][indices.ind2].couleur = .green
                }
                
                affichage = "Le Joueur gagné"
                 self.hidePlayButton = false
                if settings.soundActive {
                    playSound(sound: "riseup", type: "mp3")
                }
                
                partiesJoueur += 1
                UserDefaults.standard.set(self.partiesJoueur, forKey: "partiesJoueur")
                gameIsActive = false
                
            } else if nbOrdi == nbLineRaw {
                for i in 0..<nbLineRaw {
                    let indices = twoDim(nombre: combination[i], nbLineRaw: nbLineRaw)
                    pion[indices.ind1][indices.ind2].couleur = .green
                }
                
                affichage = "L'Ordinateur a gagné"
                self.hidePlayButton = false
                if settings.soundActive {
                    playSound(sound: "spin", type: "mp3")
                }
                
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
                
                if settings.soundActive {
                    playSound(sound: "game-over", type: "mp3")
                }
                self.hidePlayButton = false
                gameIsActive = false
            }
        }
    }
    
    func twoDimOneDim(line: Int, raw: Int, nbLineRaw: Int) -> Int {
        let value = line * nbLineRaw + raw
        return value
    }
    
    // MARK: - Converti une dimension en 2 dimentions
    func twoDim(nombre: Int, nbLineRaw: Int) -> (ind1:Int, ind2:Int) {
        var ind1 = 0
        var ind2 = 0
        if nombre < nbLineRaw {
            ind1 = 0
            ind2 = nombre
        } else if nombre < nbLineRaw * 2 {
            ind1 = 1
            ind2 = nombre - nbLineRaw
        } else if nombre < nbLineRaw * 3 {
            ind1 = 2
            ind2 = nombre - nbLineRaw * 2
        } else if nombre < nbLineRaw * 4 {
            ind1 = 3
            ind2 = nombre - nbLineRaw * 3
        } else if nombre < nbLineRaw * 5 {
            ind1 = 4
            ind2 = nombre - nbLineRaw * 4
        }else if nombre < nbLineRaw * 6 {
            ind1 = 5
            ind2 = nombre - nbLineRaw * 5
        }
        return (ind1, ind2)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - joueur: 0: Joueur, 1: Ordinateur
    ///   - winComb: Tableau de combinaisons gagnantes
    ///   - nbLineRaw: Nombre de lignes et de colonnes
    /// - Returns: retour true si trouvé
    func chercheCombinaison(joueur: Int, winComb: [[Int]], nbLineRaw: Int) -> Bool {
        var trouve = false
        
        for combination in winComb {
            // Une conbinaison trouvée
            var nbState = 0
            
            for index in 0..<nbLineRaw {
                if joueur == 1 {
                    if gameState[combination[index]] == .ordi { nbState += 1}
                }
                
                if joueur == 0 {
                    if gameState[combination[index]] == .joueur { nbState += 1}
                }
            }
            
            // Ligne presque terminée
            if nbState == nbLineRaw - 1 {
                var j = 0
                for _ in combination {
                    if gameState[combination[j]] == .vide {
                        let indices = twoDim(nombre: combination[j], nbLineRaw: nbLineRaw)
                        OrdinateurJoue(line: indices.ind1, raw: indices.ind2, nbLineRaw: nbLineRaw)
                        trouve = true
                    }
                    j += 1
                }
            }
        }
        return trouve
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(geoHeight: 640, geoWidth: 480).environmentObject(Settings())
        .previewDevice("iPhone SE")
        .environment(\.locale, .init(identifier: "en"))
    }
}
