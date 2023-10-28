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
                           detail: "Welcome. to iCoSpartan App, can you create your table workouts. Explore now.",
                           bgColor: Color.black)
                .transition(.scale)
            }
            if currentPage == 2 {
                ScreenView(image: "character-1",
                           title: "Step 2",
                           detail: "We offer access to maintain your own custom personal workouts, track what you've seen and follow instructions customized with videos in Detail View.",
                           bgColor: Color.black)
                .transition(.scale)
            }
            if currentPage == 3 {
                ScreenView(image: "character-2",
                           title: "Step 3",
                           detail: "see your table of challenges count your objectives and follow your progress.",
                           bgColor: Color.black)
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
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay(
                        ZStack{
                            Circle()
                                .stroke(Color.black.opacity(0.2), lineWidth: 2)
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
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack{
                // Se muestra si solo es la primera pagina
                if currentPage == 1 {
                    Text("Welcome to iTVShows")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                } else {
                    Button(action: {
                        withAnimation(.easeInOut){
                            currentPage -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.2))
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
    }
}

#Preview {
    OnBoardingView()
}
