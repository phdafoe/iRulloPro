//
//  Card.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 15/10/23.
//

import Foundation

class Card: NSObject, ObservableObject, Identifiable, Codable {
    
    private(set) var id = UUID()
    var boardListId: UUID
    
    @Published var content: String
    
    enum CodingKeys: String, CodingKey {
        case id, boardListId, content
    }
    
    init(boardListId: UUID, content: String) {
        self.boardListId = boardListId
        self.content = content
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.boardListId = try container.decode(UUID.self, forKey: .boardListId)
        self.content = try container.decode(String.self, forKey: .content)
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(boardListId, forKey: .boardListId)
        try container.encode(content, forKey: .content)
    }
}

extension Card: NSItemProviderWriting {
    
    static let typeIdentifier = Constants.bundleId+Constants.typeIdentifier
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, 
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }
}
