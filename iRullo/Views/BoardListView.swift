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
        }
        .padding(.vertical)
        .background(Constants.Backgroud.boardListBackgroundColor).opacity(0.8)
        .frame(width: 300)
        .cornerRadius(8)
        .foregroundColor(.black)
        .sheet(isPresented: $presentAlertTextField, content: {
            ViewDetailCard(boardList: boardList, confirmAction: { title, taskDescription  in
                handlerAddCard(title: title ?? "", taskDescription: taskDescription)
            })
        })
    }
    
    private var headerView: some View {
        HStack(alignment: .top, content: {
            Text(boardList.name).font(.headline).lineLimit(2)
            Spacer()
            Menu {
                Button("Rename"){
                    handleBoardListRename()
                }
                
                
                Button("Delete", role: .destructive){
                    board.removeBoardList(boardList: boardList)
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
                    .onDrag{
                        NSItemProvider(object: card)
                    }
            }
            .onInsert(of: [Card.typeIdentifier], perform: handleOnInsertCard)
            .onMove(perform: boardList.moveCards(fromOffsets:toOffset:))
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 4,
                                 leading: 8,
                                 bottom: 4,
                                 trailing: 8))
            .listRowBackground(Color.clear)
        }
    }
    
    private func handleOnInsertCard(index: Int, itemProviders: [NSItemProvider]) {
        for itemProvider in itemProviders {
            itemProvider.loadObject(ofClass: Card.self) { item, _ in
                guard let card = item as? Card else {
                    return
                }
                DispatchQueue.main.async {
                    board.moveCard(card: card, to: boardList, at: index)
                }
            }
        }
    }
    
    private func handleBoardListRename() {
        presentAlertTextField(title: "Rename list", defaultTextFieldText: boardList.name) { title in
            guard let titleUnw = title, !titleUnw.isEmpty else {
                return
            }
            boardList.name = titleUnw
        }
    }
    
    private func handlerAddCard(title: String, taskDescription: String? = nil) {
        boardList.addNewCardWithContent(title: title, taskDescription: taskDescription)
    }
}

