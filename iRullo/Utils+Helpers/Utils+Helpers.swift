//
//  Utils+Helpers.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 15/10/23.
//

import Foundation
import SwiftUI

struct Constants {
    
    static let bundleId = "com.icologic.iRullo"
    static let typeIdentifierCard = ".Card"
    static let typeIdentifierBoardList = ".BoardList"
    
    let kUsuario = "USUARIO"
    let kContrasena = "CONTRASENA"
    let kUsuarioLogado = "LOGADO"
    let kPreferences = UserDefaults.standard
    static let totalPages = 3
    
    struct Backgroud {
        static let boardListBackgroundColor = Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1))
        static let iRulloBackgroundColor = Color(uiColor: UIColor(red: 0.2, green: 0.47, blue: 0.73, alpha: 1))
    }
}

struct PrimaryButtonStyle: ButtonStyle{
    var fillColor: Color = Constants.Backgroud.iRulloBackgroundColor
    func makeBody(configuration: Configuration) -> some View {
        return PrimaryButton(configuration: configuration, fillColor: fillColor)
    }
    
    struct PrimaryButton: View {
        let configuration: Configuration
        let fillColor: Color
        var body: some View {
            return configuration.label
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 10).fill(fillColor))
                .foregroundColor(.white)            
        }
    }
}
