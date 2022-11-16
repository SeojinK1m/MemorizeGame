//
//  MemoryGame.swift
//  Memorize
//
//  Created by Sam Kim on 9/5/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfFaceUpCard: Int? {
        //  when using this computed variable, if there is more than one face up card or no face up card, return nil.
        //  else, return the index of the one and only face up card.
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly }
        //  when the value is externally set to newValue
        //  Flip all other cards whose index is not newValue to face-down
        set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    private(set) var score: Int
    mutating func choose(_ card: Card) {
        //  if card exists in cards, set chosenIndex to the index of that card
        //  if the card at the chosen index is face down and is not matched yet
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            //  if there is at only one card that is face up
            if let faceUpIndex = indexOfFaceUpCard {
                //  if the content of the chosen card is equal to the content of the face up card
                //  in other words, checks whether the player matched
                if card.content == cards[faceUpIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[faceUpIndex].isMatched = true
                    score += 2
                } else {
                    if cards[chosenIndex].seen {
                        score -= 1
                    }
                    if cards[faceUpIndex].seen {
                        score -= 1
                    }
                }
            } else {
                for i in cards.indices {
                    if cards[i].isFaceUp {
                        cards[i].seen = true
                        cards[i].isFaceUp = false
                    }
                }
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int)->CardContent) {
        cards = []
        for i in 0..<numberOfPairsOfCards {
            cards.append( Card(id: i*2, content: createCardContent(i)) )
            cards.append( Card(id: i*2 + 1, content: createCardContent(i)) )
        }
        cards.shuffle()
        score = 0
    }
    
    struct Card: Identifiable {
        let id: Int
        let content: CardContent
        
        var isFaceUp = false
        var isMatched = false
        var seen = false
    }
}

extension Array {
    var oneAndOnly: Element? {
        count == 1 ? first : nil
    }
}
