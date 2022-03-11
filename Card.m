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

        function cardValues = getValues(cards)
            cardValues = double.empty();
            numberCards = length(cards);
            for i = 1 : numberCards
                switch cards(i).Value
                    case "A"
                        cardValues(i) = 14;
                    case "K"
                        cardValues(i) = 13;
                    case "Q"
                        cardValues(i) = 12;
                    case "J"
                        cardValues(i) = 11;
                    otherwise
                        cardValues(i) = str2double(cards(i).Value);
                end
            end
        end

        function boolean = isEqual(cards1, cards2)
            boolean = ([cards1.Suit] == [cards2.Suit]) & ([cards1.getValues()] == [cards2.getValues()]);
        end
    end
end