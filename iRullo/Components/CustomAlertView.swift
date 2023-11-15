//
//  CustomAlertView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 28/10/23.
//

import SwiftUI

struct CustomAlertView: View {
    
    
    @State var title: String
    var message: String? = nil
    @Binding var hideCustomAlertView: Bool
    var deleteAccount: ((Bool) -> ())?
    var cancelAction: ((Bool) -> ())?
    var saveAction: ((Bool) -> ())?
    var myNewTitle: ((String) -> ())?
    @State var myTextField: String
    var isDeleteAccount: Bool
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                HStack{
                    Spacer()
                    Text(title)
                        .bold()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button {
                        self.hideCustomAlertView.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    
                }
//                Divider()
                
                if isDeleteAccount{
                    Text(message ?? "")
                        .font(.custom("Arial", size: 18))
                    Button {
                        self.deleteAccount?(true)
                    } label: {
                        Text("Delete")
                    }
                } else {
                    TextField("new Title", text: self.$myTextField)
                    HStack{
                        Button {
                            self.cancelAction?(true)
                        } label: {
                            Text("Cancel")
                        } 
                        Spacer()
                        Button {
                            self.saveAction?(true)
                            self.myNewTitle?(self.myTextField)
                        } label: {
                            Text("Save")
                        }
                    }
                    .padding()
                }
                
            }
            .padding()
            .frame(width: 250)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .shadow(radius: 10)
        }
        
    }
}
