//
//  MainView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 28/10/23.
//

import SwiftUI

struct MainView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    @EnvironmentObject var session: LoginViewModel
    
    var body: some View {
        if currentPage > Constants.totalPages {
            if self.session.usuarioLogado != nil {
                BoardView()
            } else {
                LoginView(tipoAutentication: !self.session.localUsuarioLogado() ? .sigin : .signup)
            }
        } else {
            OnBoardingView()
        }
    }
}

#Preview {
    MainView()
}
