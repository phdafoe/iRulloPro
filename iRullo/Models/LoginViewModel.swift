//
//  LoginViewModel.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 28/10/23.
//

import Foundation
import FirebaseAuth
import CryptoKit

enum LoginOption {
    case inicioSesionConApple(idTokenString: String, nonceDes: String)
    case emailAndPassword(email: String, password: String)
}

enum TipoAutenticacion: String {
    case sigin
    case signup
    
    var text: String {
        rawValue.capitalized
    }
    
    var footerText: String {
        switch self {
        case .sigin:
            return "you're not member, SignUp"
        case .signup:
            return "Ready for to be part of iRullo?"
        }
    }
}

final class LoginViewModel: ObservableObject {
    
    @Published var usuarioLogado: User?
    @Published var cambioPassword: Bool?
    @Published var usuarioAutenticado = false
    @Published var error: NSError?
    @Published var currentNonce:String?
    @Published var isLoading = false
    
    private let authenticationData = Auth.auth()
    
    required init() {
        usuarioLogado = authenticationData.currentUser
        authenticationData.addStateDidChangeListener(estadoDeAutenticacionModificado)
    }
    
    private func estadoDeAutenticacionModificado(with auth: Auth, user: User?) {
        guard user != self.usuarioLogado else { return }
        self.usuarioLogado = user
    }
    
    // Login
    func acceso(with loginOption: LoginOption) {
        self.usuarioAutenticado = true
        self.error = nil
        self.isLoading = true
        switch loginOption {
        case let .inicioSesionConApple(idTokenString, nonceDes):
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonceDes)
            
            authenticationData.signIn(with: credential, completion: manejadorFoinalizacionDelResultadoDeAutenticacion)
        case let .emailAndPassword(email, password):
            authenticationData.signIn(withEmail: email,
                                      password: password,
                                      completion: manejadorFoinalizacionDelResultadoDeAutenticacion)
        }
    }
    
    // Registro
    func registro(email: String, password: String, passwordConfirmation: String) {
        guard password == passwordConfirmation else {
            self.error = NSError(domain: "", code: 9210, userInfo: [NSLocalizedDescriptionKey : "La password y la confirmacion no son iguales"])
            return
        }
        self.usuarioAutenticado = true
        self.error = nil
        Constants().kPreferences.set(true, forKey: Constants().kUsuarioLogado)
        authenticationData.createUser(withEmail: email,
                                      password: password,
                                      completion: manejadorFoinalizacionDelResultadoDeAutenticacion)
    }
    
    // Logout
    func desconectarSesion() {
        do {
            try authenticationData.signOut()
        } catch {
            self.error = NSError(domain: "", code: 9999, userInfo: [NSLocalizedDescriptionKey : "El usuario no ha logrado desconectar la sesion"])
        }
    }
    
    // Delete account
    func deleteAccountFirebase(){
        authenticationData.currentUser?.delete()
    }
    
    
    // Callback
    private func manejadorFoinalizacionDelResultadoDeAutenticacion(with auth: AuthDataResult?, and error: Error?) {
        DispatchQueue.main.async {
            self.usuarioAutenticado = false
            if let user = auth?.user {
                self.isLoading = false
                self.usuarioLogado = user
            } else if let errorDes = error {
                self.error = errorDes as NSError
            }
        }
    }
    
    func localUsuarioLogado() -> Bool {
        if Constants().kPreferences.bool(forKey: Constants().kUsuarioLogado) {
            return true
        } else {
            return false
        }
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}
