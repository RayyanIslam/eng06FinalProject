classdef Card
    properties
        Suit
        Value
    end

    methods
        function card = Card(suit, value)
            card.Suit = suit;
            card.Value = value;
        end

        function cardValueNumber = getCardValue(card)
            switch card.Value
                case "A"
                    cardValueNumber = 14;
                case "K"
                    cardValueNumber = 13;
                case "Q"
                    cardValueNumber = 12;
                case "J"
                    cardValueNumber = 11;
                otherwise
                    cardValueNumber = str2double(card.Value);
            end
        end
    end
end