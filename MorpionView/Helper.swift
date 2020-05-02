//
//  Helper.swift
//  ProgressBar
//
//  Created by Michel Garlandat on 02/05/2020.
//  Copyright © 2020 Michel Garlandat. All rights reserved.
//

import Foundation
import SwiftUI

public struct CustomButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width/5, height: 20)
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10.0)
            .font(.title)
    }
}
