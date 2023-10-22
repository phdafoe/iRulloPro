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
    
    @Published var title: String
    @Published var taskDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id, boardListId, title, taskDescription
    }
    
    init(boardListId: UUID, title: String, taskDescription: String) {
        self.boardListId = boardListId
        self.title = title
        self.taskDescription = taskDescription
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.boardListId = try container.decode(UUID.self, forKey: .boardListId)
        self.title = try container.decode(String.self, forKey: .title)
        self.taskDescription = try container.decode(String.self, forKey: .taskDescription)
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(boardListId, forKey: .boardListId)
        try container.encode(title, forKey: .title)
        try container.encode(taskDescription, forKey: .taskDescription)
    }
}

extension Card: NSItemProviderWriting {
    
    static let typeIdentifier = Constants.bundleId+Constants.typeIdentifierCard
    
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

extension Card: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    static func object(withItemProviderData data: Data, 
                       typeIdentifier: String) throws -> Self {
        
        try JSONDecoder().decode(Self.self, from: data)
    }
}
