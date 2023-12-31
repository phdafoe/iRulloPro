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
    
    @Binding var lists: [BoardList]
    @Binding var current: BoardList?
    
    private func boardListItemProviders(info: DropInfo) -> [NSItemProvider] {
        info.itemProviders(for: [BoardList.typeIdentifier])
    }
    
    private func cardItemProviders(info: DropInfo) -> [NSItemProvider] {
        info.itemProviders(for: [Card.typeIdentifier])
    }
    
    func dropEntered(info: DropInfo) {
        guard
            !boardListItemProviders(info: info).isEmpty,
            let currentUnw = current,
            boardlist != currentUnw,
            let fromIndex = lists.firstIndex(of: currentUnw),
            let toIndex = lists.firstIndex(of: boardlist) else {
            return
        }
        lists.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1: toIndex)
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        if !cardItemProviders(info: info).isEmpty {
            return DropProposal(operation: .copy)
        } else if !boardListItemProviders(info: info).isEmpty{
            return DropProposal(operation: .move)
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
        self.current = nil
        return true
    }
}
