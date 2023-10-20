//
//  Board+Stub.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 15/10/23.
//

import Foundation

extension Board {
    
    static var stub: Board {
        let board = Board(name: "iRullo")
        
        let backlogBoardList = BoardList(boardId: board.id, name: "Backlog")
        let backlogCards = [
            "Cloud Service",
            "Ingestion Engine",
            "Comprension Engine",
            "DDBB Service",
            "Routing Service",
            "Scheme design",
            "Analytics"
        ].map {
            Card(boardListId: backlogBoardList.id, content: $0)
        }
        
        backlogBoardList.cards = backlogCards
        
        let todoBacklogList = BoardList(boardId: board.id, name: "To do")
        let todoBacklogCards = [
            "Routing Service",
            "Scheme design",
            "Analytics"
        ].map {
            Card(boardListId: todoBacklogList.id, content: $0)
        }
        
        todoBacklogList.cards = todoBacklogCards
        
        let inProgressList = BoardList(boardId: board.id, name: "In Progress")
        let inProgressCards = [
            "Error Handling",
            "Scheme design UX - UI",
            "Analytics App on Firebase"
        ].map {
            Card(boardListId: inProgressList.id, content: $0)
        }
        
        inProgressList.cards = inProgressCards
        
        
        let doneList = BoardList(boardId: board.id, name: "Done")
        
        
        board.lists = [
            backlogBoardList,
            todoBacklogList,
            inProgressList,
            doneList
        ]
        
        return board
    }
}
