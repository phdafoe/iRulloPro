//
//  BoardView.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 20/10/23.
//

import SwiftUI

struct BoardView: View {
    
    @StateObject private var board: Board = Board.stub
    
    var body: some View {
        NavigationView{
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 24, content: {
                    ForEach(board.lists) { boardList in
                        BoardListView(board: board, boardList: boardList)
                    }
                    
                    Button(action: {
                        
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
            }
            .background(Image("macos")
                .resizable()
                .edgesIgnoringSafeArea(.bottom))
            .navigationTitle(board.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    BoardView()
}
