//
//  LoginView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 27/10/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    // MARK: ObservedObject -> MVVM Dependencies
    @EnvironmentObject var viewModel: LoginViewModel
    @State var tipoAutentication: TipoAutenticacion
    
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""
    @State var showPassword = false
    
    var mainContentLoginView: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "email",
                            title: "email",
                            text: self.$email)
            .padding(10)
            .background(Color(red: 239/255, green: 243/255, blue: 244/255))
            .cornerRadius(10)
            .shadow(radius: 5)
            
            if showPassword {
                CustomTextField(placeholder: "password",
                                title: "password",
                                text: self.$password)
                .padding(10)
                .background(Color(red: 239/255, green: 243/255, blue: 244/255))
                .cornerRadius(10)
                .shadow(radius: 5)
            } else {
                CustomSecuretextField(placeholder: "password",
                                      title: "password",
                                      text: self.$password)
                .padding(10)
                .background(Color(red: 239/255, green: 243/255, blue: 244/255))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            if tipoAutentication == .signup {
                if showPassword {
                    CustomTextField(placeholder: "password confirmation",
                                    title: "password confirmation",
                                    text: self.$passwordConfirmation)
                    .padding(10)
                    .background(Color(red: 239/255, green: 243/255, blue: 244/255))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                } else {
                    CustomSecuretextField(placeholder: "password confirmation",
                                          title: "password confirmation",
                                          text: self.$passwordConfirmation)
                    .padding(10)
                    .background(Color(red: 239/255, green: 243/255, blue: 244/255))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
            
            SignInWithAppleButton(
                onRequest: { request in
                    let nonce = self.viewModel.randomNonceString()
                    self.viewModel.currentNonce = nonce
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = self.viewModel.sha256(nonce)
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            guard let nonce = self.viewModel.currentNonce else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let appleIDToken = appleIDCredential.identityToken else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                return
                            }
                            self.viewModel.acceso(with: .inicioSesionConApple(idTokenString: idTokenString, nonceDes: nonce))
                        default: break
                        }
                    case .failure(_):
                        break
                    }
                }
            )
            .frame(width: 280, height: 45, alignment: .center)
            
            Toggle("Show Password", isOn: self.$showPassword)
                .padding(10)
                .foregroundColor(Color.red)
                .font(.caption)
            
            // Boton de login / registro
            Button(action: {
                self.autenticationEmailPulsado()
            }) {
                Text(tipoAutentication.text)
                    .font(.headline)
                    .foregroundColor(Color.red)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                    .cornerRadius(25)
            }
            
            
            // Boton de cambio formualario si estoy logado o no
            Button(action: {
                self.botonFooterPulsado()
            }) {
                Text(tipoAutentication.footerText)
                    .lineLimit(3)
                    .font(.headline)
            }
            .foregroundColor(Color.red)
            .padding()
        }
    }
    
    var body: some View {
        ZStack{
            if viewModel.isLoading{
                //HudView()
            } else {
                ScrollView{
                    VStack(spacing: 40){
                        helloApp
                        imageAppLogo
                        if !viewModel.usuarioAutenticado {
                            mainContentLoginView
                        }
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var helloApp: some View {
        Text("iRullo")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 10)
            .foregroundColor(Color.red)
            .padding(.top, 20)
        
    }
    var imageAppLogo: some View {
        Image("Blue Light")
            .resizable()
            .frame(width: 250, height: 250)
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 20)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 0)
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
    }
    
    private func autenticationEmailPulsado() {
        switch tipoAutentication {
        case .sigin:
            self.viewModel.acceso(with: .emailAndPassword(email: self.email, password: self.password))
        case .signup:
            self.viewModel.registro(email: self.email, password: self.password, passwordConfirmation: self.passwordConfirmation)
        }
    }
    
    private func botonFooterPulsado() {
        self.limpiarCamposFormulario()
        self.tipoAutentication = tipoAutentication == .signup ? .sigin : .signup
    }
    
    private func limpiarCamposFormulario() {
        self.email = ""
        self.password = ""
        self.passwordConfirmation = ""
        self.showPassword = false
    }
}

#Preview {
    LoginView(tipoAutentication: .sigin)
}
