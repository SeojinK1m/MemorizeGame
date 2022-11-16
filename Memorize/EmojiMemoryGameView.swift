//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Sam Kim on 9/3/22.
//

import SwiftUI

//  ContentView *behaves* like a View
struct EmojiMemoryGameView: View {
    //  @ObservedObject makes it so that the view listens for change from this var
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            // Title
            HStack {
                VStack {
                    Text("Memorize!")
                }
                Spacer()
                Text(String(game.getScore()))
                    .font(.largeTitle)
            }
            Text(game.chosenTheme._name)
            
            //  cards
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                if card.isMatched && !card.isFaceUp {
                    Rectangle().opacity(0)
                } else {
                    CardView(card)
                        .onTapGesture {
                            game.choose(card)
                        }
                        .padding(4)
                }
            }
            .foregroundColor(.orange)
            
            //  Button
            HStack {
                Spacer()
                Button(action: game.createNewGame) {
                    Text("New Game")
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .font(.largeTitle)
    }
}

struct CardView: View {
    private let _card: EmojiMemoryGame.Card
    
    init(_ card: EmojiMemoryGame.Card) {
        _card = card
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        
        GeometryReader{ geometry in
            ZStack {
                if _card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.borderWidth)
                    Pie(
                        startAngle: Angle(degrees: 0-90),
                        endAngle: Angle(degrees: 110-90)
                    )
                        .padding(DrawingConstants.circlePadding)
                        .opacity(DrawingConstants.circleOpacity)
                    Text(_card.content).font(font(geometry.size))
                } else if _card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(_ size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.6
        static let circleOpacity: CGFloat = 0.5
        static let circlePadding: CGFloat = 5
    }
}










//  glue code, just loads the preview. not important!!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}
