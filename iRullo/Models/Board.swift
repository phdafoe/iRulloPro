//
//  Board.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 15/10/23.
//

import Foundation

class Board: ObservableObject, Identifiable {
    
    private(set) var id = UUID()
    
    @Published var name: String
    @Published var lists: [BoardList]
    
    init(name: String, lists: [BoardList] = []) {
        self.name = name
        self.lists = lists
    }
    
    func moveCard(card: Card, to boardlist: BoardList, at index: Int) {
        guard
            let sorceBoardListIndex = boardListIndex(id: card.boardListId),
            let destinationBoardListIndex = boardListIndex(id: boardlist.id),
            sorceBoardListIndex != destinationBoardListIndex,
            let sourceCardIndex = cardIndex(id: card.id, boardIndex: sorceBoardListIndex)
        else {
            return
        }
        
        boardlist.cards.insert(card, at: index)
        card.boardListId = boardlist.id
        lists[sorceBoardListIndex].cards.remove(at: sourceCardIndex)
    }
    
    private func cardIndex(id: UUID, boardIndex: Int) -> Int? {
        lists[boardIndex].cardIndex(id: id)
    }
    
    private func boardListIndex(id: UUID) -> Int? {
        lists.firstIndex { $0.id == id }
    }
    
}
