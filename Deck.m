classdef Deck < handle
    properties
        Cards
    end

    methods
        function deck = Deck()
            deck.Cards = Card.empty(0, 52);
            counter = 1;
            for i = 1 : 4
                for j = 1 : 13
                    switch i
                        case 1
                            suit = "Spade";
                        case 2
                            suit = "Heart";
                        case 3
                            suit = "Club";
                        otherwise
                            suit = "Diamond";
                    end
                    switch j
                        case 1
                            value = "A";
                        case 11
                            value = "J";
                        case 12
                            value = "Q";
                        case 13
                            value = "K";
                        otherwise
                            value = num2str(j);
                    end
                    deck.Cards(counter) = Card(suit, value);
                    counter = counter + 1;
                end
            end
            deck.shuffle();
        end

        function deck = shuffle(deck)
            cards = deck.Cards;
            deckSize = length(cards);
            shuffledDeck = Card.empty(0, deckSize);
            for i = 1 : deckSize
                index = floor(rand(1) * (deckSize - i)) + 1;
                shuffledDeck(i) = cards(index);
                cards(index) = [];
            end
            deck.Cards = shuffledDeck;
        end

        function card = drawCard(deck)
            card = deck.Cards(1);
            deck.Cards(1) = [];
        end
    end
end