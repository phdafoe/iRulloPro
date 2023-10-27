//
//  BoardView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 20/10/23.
//

import SwiftUI

struct BoardView: View {
    
    @StateObject private var board: Board = Board.stub
    @State private var dragging: BoardList?
    
    let myArray = ["macos", "macos1", "macos2", "macos3", "macos4"]
    @State var activeImageIndex = 0
    let imageSwitchTimer = Timer.publish(every: 21600, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 24, content: {
                    ForEach(board.lists) { boardList in
                        BoardListView(board: board, boardList: boardList)
                            .onDrag({
                                self.dragging = boardList
                                return NSItemProvider(object: boardList)
                            })
                            .onDrop(of: [Card.typeIdentifier, BoardList.typeIdentifier], delegate: BoardDropDelegate(board: board,
                                                                                           boardlist: boardList,
                                                                                           lists:$board.lists,
                                                                                           current: $dragging))
                    }
                    
                    Button(action: {
                        handleOnAddList()
                    }, label: {
                        Text("+ Add")
                    })
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.Backgroud.boardListBackgroundColor).opacity(0.8)
                    .frame(width: 300)
                    .cornerRadius(8)
                    .foregroundColor(.black)
                })
                .padding()
                .animation(.default, value: board.lists)
            }
            .background(Image(myArray[activeImageIndex])
                .resizable()
                .edgesIgnoringSafeArea(.bottom))
            .navigationTitle(board.name)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(imageSwitchTimer) { _ in
                self.activeImageIndex = (self.activeImageIndex + 1) % self.myArray.count
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func handleOnAddList() {
        presentAlertTextField(title: "Add List") { title in
            guard let titleUnw = title, !titleUnw.isEmpty else {
                return
            }
            board.addNewBoardListWithName(nameBoard: titleUnw)
        }
    }

}

#Preview {
    BoardView()
}
