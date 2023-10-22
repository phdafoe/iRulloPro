//
//  BoardDropDelegate.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 22/10/23.
//

import Foundation
import SwiftUI

struct BoardDropDelegate: DropDelegate {
    
    let board: Board
    let boardlist: BoardList
    
    private func cardItemProviders(info: DropInfo) -> [NSItemProvider] {
        info.itemProviders(for: [Card.typeIdentifier])
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        if !cardItemProviders(info: info).isEmpty {
            return DropProposal(operation: .copy)
        }
        return nil
    }
    
    func performDrop(info: DropInfo) -> Bool {
        let cardItemProviders = cardItemProviders(info: info)
        for cardItemProvider in cardItemProviders {
            cardItemProvider.loadObject(ofClass: Card.self) { item, _ in
                guard
                    let card = item as? Card,
                    card.boardListId != boardlist.id else {
                    return
                }
                DispatchQueue.main.async {
                    board.moveCard(card: card, to: boardlist, at: 0)
                }
            }
        }
        return true
    }
}
