//
//  BoardList.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 15/10/23.
//

import Foundation

class BoardList: ObservableObject, Identifiable {
    
    private(set) var id = UUID()
    var boardId: UUID
    
    @Published var name: String
    @Published var cards: [Card]
    
    
    init(boardId: UUID, name: String, cards: [Card] = []) {
        self.boardId = boardId
        self.name = name
        self.cards = cards
    }
    
}
