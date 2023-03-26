//
//  Card.swift
//  DeckOfCards
//
//  Created by Alexey Manokhin on 25.03.2023.
//

import Foundation

struct ResponseCard: Decodable {
    let success: Bool
    let deck_id: String
    let cards: [Card]
    let remaining: Int
}

struct Card: Decodable {
    let code: String
    let image: URL
    var images: CardImage
    let value: String
    let suit: String
}

struct CardImage: Decodable {
    let svg: URL
    let png: URL
}
