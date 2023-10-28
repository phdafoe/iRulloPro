//
//  SplashView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 28/10/23.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject var viewModel: SplashViewModel
    
    var body: some View {
        ZStack{
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
                .fullScreenCover(isPresented: self.$viewModel.canNavigate) {
                    //
                } content: {
                    MainView().environmentObject(LoginViewModel())
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel())
}
