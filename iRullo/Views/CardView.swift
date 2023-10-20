//
//  CardView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 20/10/23.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var boardList: BoardList
    @StateObject var card: Card
    
    var body: some View {
        HStack{
            Text(card.content).lineLimit(3)
            Spacer()
            Menu{
                Button("Rename"){
                    
                }
                Button("Delete", role: .destructive){
                    
                }
            }label: {
                Image(systemName: "ellipsis.rectangle").imageScale(.small)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(4)
        .shadow(radius: 1, y: 1)
        
    }
}


