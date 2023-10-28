//
//  CustomTextField.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 28/10/23.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var title: String
    var text: Binding<String>
    
    var body: some View {
        HStack{
            Image(systemName: "person").foregroundColor(Color.red)
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color.gray)
                    .offset(y: text.wrappedValue.isEmpty ? 0 : -25)
                    .scaleEffect(text.wrappedValue.isEmpty ? 1: 0.8, anchor: .leading)
                TextField(placeholder, text: text)
                    .foregroundColor(Color.black)
            }
            .padding(.top, 15)
            //.animation(.spring(response: 0.2, dampingFraction: 0.5))
        }
        
    }
}

struct CustomSecuretextField: View {
    
    var placeholder: String
    var title: String
    var text: Binding<String>
    
    var body: some View {
        HStack{
            Image(systemName: "lock").foregroundColor(Color.red)
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color.gray)
                    .offset(y: text.wrappedValue.isEmpty ? 0 : -25)
                    .scaleEffect(text.wrappedValue.isEmpty ? 1: 0.8, anchor: .leading)
                SecureField(placeholder, text: text)
                    .foregroundColor(Color.black)
                
            }
            .padding(.top, 15)
            //.animation(.spring(response: 0.2, dampingFraction: 0.5))
        }
        
    }
}

#Preview {
    CustomSecuretextField(placeholder: "Email", title: "Email", text: .constant("Email"))
}
