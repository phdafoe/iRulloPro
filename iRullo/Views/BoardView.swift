//
//  BoardView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 20/10/23.
//

import SwiftUI

struct BoardView: View {
    
    @StateObject private var board: Board = BoardDiskRepository().loadFromDisk() ?? Board.stub
    @State private var dragging: BoardList?
    @State private var presentProfile = false
    @State private var customAlertRename = false
    @State private var customAlertAddList = false
    @State private var isCustomAlert = false
    @State private var nameBoard = ""
    
    let myArray = ["macos", "macos1", "macos2", "macos3", "macos4"]
    @State var activeImageIndex = 0
    let imageSwitchTimer = Timer.publish(every: 21600, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            ZStack{
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
                            self.customAlertAddList.toggle()
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
                    .edgesIgnoringSafeArea([.bottom, .leading, .trailing]))
                .navigationTitle(board.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    HStack{
                        Button(action: {
                            self.customAlertRename.toggle()
                        }, label: {
                            Image(systemName: "ellipsis.circle").imageScale(.large)
                        })
                        .sheet(isPresented: self.$customAlertRename) {
                            
                        }
                        Button(action: {
                            loadProfile()
                        }, label: {
                            Image(systemName: "person.circle").imageScale(.large)
                        })
                        .sheet(isPresented: $presentProfile, content: {
                            ViewProfile()
                        })
                    }
                }
                .onReceive(imageSwitchTimer) { _ in
                    self.activeImageIndex = (self.activeImageIndex + 1) % self.myArray.count
                }
            }
            
            if customAlertAddList{
                CustomAlertView(title: "New List in Board",
                                message: board.name,
                                hideCustomAlertView: self.$isCustomAlert,
                                deleteAccount: { _ in
                    //
                },
                                cancelAction: { value in
                    if value {
                        self.customAlertAddList.toggle()
                    }
                },
                                saveAction: { value in
                    if value {
                        self.customAlertAddList.toggle()
                    }
                },
                                myNewTitle: { title in
                    self.board.name = title
                },
                                myTextField: board.name,
                                isDeleteAccount: false)
            }
                
            
            if customAlertRename {
                CustomAlertView(title: "Rename Board",
                                message: board.name,
                                hideCustomAlertView: self.$isCustomAlert,
                                deleteAccount: { _ in
                    //
                },
                                cancelAction: { value in
                    if value {
                        self.customAlertRename.toggle()
                    }
                },
                                saveAction: { value in
                    if value {
                        self.customAlertRename.toggle()
                    }
                },
                                myNewTitle: { title in
                    self.board.name = title
                },
                                myTextField: board.name,
                                isDeleteAccount: false)
            }
            
        }
        .navigationViewStyle(.stack)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            BoardDiskRepository().saveToDisk(board: board)
        }
    }
    
    private func handleOnAddList() {
        presentAlertTextField(title: "Add List") { title in
            guard let titleUnw = title, !titleUnw.isEmpty else {
                return
            }
            board.addNewBoardListWithName(nameBoard: titleUnw)
        }
    }
    
    private func handleRenameBoard() {
        presentAlertTextField(title: "Rename Board", defaultTextFieldText: board.name) { text in
            guard let titleUnw = text, !titleUnw.isEmpty else {
                return
            }
            board.name = titleUnw
        }
    }
    
    private func loadProfile() {
        self.presentProfile.toggle()
    }

}

#Preview {
    BoardView()
}
