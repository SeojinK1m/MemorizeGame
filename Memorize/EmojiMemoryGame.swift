//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sam Kim on 9/6/22.
//

import SwiftUI

//  ObservableObject basicaly turns the viewmodel into a publisher of events. its in the name: its changes observable by other components
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private var themes: Array<Theme>
    private(set) var chosenTheme: Theme
    //  @Published vars publishes changes whenever the var changes
    @Published private var model: MemoryGame<String>
    
    init() {
        let theme1: Theme
        let theme2: Theme
        let theme3: Theme
        theme1 = Theme(
            color: "Orange",
            emojis: ["⏱", "🔠", "🛫", "😢", "⏸", "⚔", "📬", "🏔", "😖" ,"🔰", "🗓", "🏓", "🍗", "💐", "💋", "👅", "📎", "*⃣", "⛔️", "🎖", "🛤", "🐒", "👧", "🕰", "a", "b", "c"],
            name: "theme1",
            numberOfPairsOfCards: 12
        )
        
        theme2 = Theme(
            color: "Blue",
            emojis: ["⏱", "🔠"],
            name: "theme2")
        
        theme3 = Theme(
            color: "Red",
            emojis: ["*⃣", "⛔️", "🎖", "🛤", "🐒", "👧", "🕰"],
            name: "theme3")
        
        themes = [theme1, theme2, theme3]
        chosenTheme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(chosenTheme)
    }
    
    private static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme._numberOfPairsOfCards) { index in return theme._emojis[index] }
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    //  MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func createNewGame() {
        chosenTheme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(chosenTheme)
    }
    
    func getScore() -> Int {
        model.score
    }
}

struct Theme {
    let _color: String
    let _emojis: Array<String>
    let _name: String
    let _numberOfPairsOfCards: Int
    
    init(color: String, emojis: Array<String>, name: String) {
        _color = color
        _emojis = emojis.shuffled()
        _name = name
        _numberOfPairsOfCards = _emojis.count
    }
    
    init(color: String, emojis: Array<String>, name: String, numberOfPairsOfCards: Int) {
        _color = color
        _emojis = emojis.shuffled()
        _name = name
        _numberOfPairsOfCards = numberOfPairsOfCards
    }
}
