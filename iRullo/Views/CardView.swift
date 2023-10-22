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
    
    @State var presentAlertTextField = false
    
    var body: some View {
        HStack{
            Text(card.title).lineLimit(3)
            Spacer()
            Menu{
                Button("Edit"){
                    presentAlertTextField.toggle()
                }
                Button("Delete", role: .destructive){
                    boardList.removeCard(card: card)
                }
            }label: {
                Image(systemName: "ellipsis.rectangle").imageScale(.small)
            }
            .sheet(isPresented: $presentAlertTextField, content: {
                ViewDetailCard(boardList: boardList,
                               tapNewName: card.title,
                               tapNewDescription: card.taskDescription,
                               confirmAction: { title, taskDescription  in
                    handleEditCard(title: title ?? "", taskDescription: taskDescription ?? "")
                })
            })
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(4)
        .shadow(radius: 1, y: 1)
        
    }
    
    private func handleEditCard(title: String, taskDescription: String ) {
        card.title = title
        card.taskDescription = taskDescription
    }
}


