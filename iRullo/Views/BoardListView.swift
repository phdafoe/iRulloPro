//
//  BoardListView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 20/10/23.
//

import SwiftUI
import SwiftUIIntrospect

struct BoardListView: View {
    
    @ObservedObject var board: Board
    @StateObject var boardList: BoardList
    
    @State var listHeight: CGFloat = 0
    @State var presentAlertTextField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            headerView
            listView
                .listStyle(.plain)
            
            Button("+ Add"){
                presentAlertTextField.toggle()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: $presentAlertTextField, content: {
                ViewDetailCard(boardList: boardList, confirmAction: { text in
                    handlerAddCard(text: text ?? "")
                })
            })
        }
        .padding(.vertical)
        .background(Constants.Backgroud.boardListBackgroundColor).opacity(0.8)
        .frame(width: 300)
        .cornerRadius(8)
        .foregroundColor(.black)
    }
    
    private var headerView: some View {
        HStack(alignment: .top, content: {
            Text(boardList.name).font(.headline).lineLimit(2)
            Spacer()
            Menu {
                Button("Rename"){
                    
                }
                
                Button("Delete", role: .destructive){
                    
                }
            } label: {
                Image(systemName: "ellipsis.circle").imageScale(.large)
            }

        })
        .padding(.horizontal)
    }
    
    private var listView: some View {
        List{
            ForEach(boardList.cards) { card in
                CardView(boardList: boardList, card: card)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 4,
                                 leading: 8,
                                 bottom: 4,
                                 trailing: 8))
            .listRowBackground(Color.clear)
        }
    }
    
    private func handlerAddCard(text: String) {
        boardList.addNewCardWithContent(content: text)
    }
}

