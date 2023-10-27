//
//  Board.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 15/10/23.
//

import Foundation

class Board: ObservableObject, Identifiable, Codable {
    
    private(set) var id = UUID()
    
    @Published var name: String
    @Published var lists: [BoardList]
    
    enum CodingKeys: String, CodingKey {
        case id, name, lists
    }
    
    init(name: String, lists: [BoardList] = []) {
        self.name = name
        self.lists = lists
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.lists = try container.decode([BoardList].self, forKey: .lists)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(lists, forKey: .lists)
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
    
    func addNewBoardListWithName(nameBoard: String) {
        lists.append(BoardList(boardId: id, name: nameBoard))
    }
    
    func removeBoardList(boardList: BoardList) {
        guard let index = boardListIndex(id: boardList.id) else {
            return
        }
        lists.remove(at: index)
    }
    
    private func cardIndex(id: UUID, boardIndex: Int) -> Int? {
        lists[boardIndex].cardIndex(id: id)
    }
    
    private func boardListIndex(id: UUID) -> Int? {
        lists.firstIndex { $0.id == id }
    }
    
}
