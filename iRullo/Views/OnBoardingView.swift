//
//  OnBoardingView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 28/10/23.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack{
            if currentPage == 1 {
                ScreenView(image: "rocket",
                           title: "Step 1",
                           detail: "Welcome. to iRullo App, can you create your table Backlog, to do, and more. Explore now.",
                           bgColor: Color.white)
                .transition(.scale)
            }
            if currentPage == 2 {
                ScreenView(image: "character-1",
                           title: "Step 2",
                           detail: "We offer access to keep your personalized tasks in projects, track what you've completed and track your progress and upcoming tasks.",
                           bgColor: Color.white)
                .transition(.scale)
            }
            if currentPage == 3 {
                ScreenView(image: "character-2",
                           title: "Step 3",
                           detail: "See your table of challenges count your objectives and follow your progress.",
                           bgColor: Color.white)
                .transition(.scale)
            }
        }
        .overlay(
            
            Button(action: {
                // Aqui cambiamos de pagina
                withAnimation(.easeInOut) {
                    if currentPage <= Constants.totalPages {
                        currentPage += 1
                    } else {
                        currentPage = 1
                    }
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                    .background(Color.black)
                    .clipShape(Circle())
                    .overlay(
                        ZStack{
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(Constants.totalPages))
                                .stroke(Color.red, lineWidth: 3)
                                .rotationEffect(.degrees(-90))
                        }.padding(-15)
                    )
                
            }.padding(.top, 20), alignment: .top
        )
    }
}

struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    @State private var animationAmount = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack{
                // Se muestra si solo es la primera pagina
                if currentPage == 1 {
                    Text("Welcome to iRullo")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                } else {
                    Button(action: {
                        withAnimation(.easeInOut){
                            currentPage -= 1
                            animationAmount += 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut){
                        currentPage = 4
                    }
                }) {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.4)
                        .foregroundColor(Color.red)
                }
            }
            .foregroundColor(.black)
            .padding()
            
            //Spacer()
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(animationAmount/2)
                .animation(.easeInOut(duration: 1), value: animationAmount)
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding(.top)
            Text(detail)
                .font(.headline)
                .fontWeight(.semibold)
                .kerning(1.4)
                .multilineTextAlignment(.center)
            
            Spacer()
            
        }
        .background(bgColor.ignoresSafeArea())
        .onAppear(perform: {
            animationAmount += 1
        })
    }
}

#Preview {
    OnBoardingView()
}
