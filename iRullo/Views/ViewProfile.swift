//
//  ViewProfile.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 27/10/23.
//

import SwiftUI

struct ViewProfile: View {
    
    @EnvironmentObject var session: LoginViewModel
    @State private var isMusicPresented = false
    @State private var isCalendarPresented = false
    @State private var isCustomAlert = false
    @State private var deleteAccount = false
    
    var body: some View {
        if self.session.usuarioLogado != nil {
            ZStack{
                Form{
                    Section("Profile data") {
                        HStack{
                            Image(systemName: "person.circle")
                                .font(.headline)
                                .foregroundColor(Color.black)
                            Text(self.session.usuarioLogado?.email ?? "")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        Button(action: {
                            self.session.desconectarSesion()
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .font(.title3)
                        
                        Button(action: {
                            self.isCustomAlert.toggle()
                        }) {
                            Text("Delete Account")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .font(.title3)
                    }
                }
                
                if isCustomAlert {
                    CustomAlertView(title: "Are you Sure?",
                                    message: "If you want delete your account in iRullo, not problem that, remember come back again when do you want",
                                    hideCustomAlertView: self.$isCustomAlert,
                                    myTextField: "",
                                    isDeleteAccount: true)
                }
            }
            
        } else {
            MainView()
        }
    }
}

#Preview {
    ViewProfile()
}
