classdef Hand < handle
    properties
        Cards
        Straight
        Flush
    end
    
    methods
        function hand = Hand(pocket, community)
            hand.Cards = hand.sortCards([pocket, community]);
        end

        function ranking = getRanking(hand)
            matchingCards = hand.getMatchingCards();
            if hand.isStraight()
                if hand.isFlush()
                    
                end
            elseif hand.isFlush()
                
            elseif unique(matchingCards)
                
            end
        end

        function sortedCards = sortCards(~, cards)
            [~, index] = sort(cards.getValues());
            sortedCards = cards(index);
        end

        function matchingCards = getMatchingCards(hand)
            handSize = length(hand.Cards);
            cardValues = hand.Cards.getValues();
            logicalIndices = [0, diff(cardValues) == 0];
            for i = 2 : handSize
                if logicalIndices(i) == 1
                    logicalIndices(i - 1) = 1;
                end
            end
            matchingCards = hand.Cards(logical(logicalIndices));
        end

        function boolean = isFlush(hand)
            suits = unique([hand.Cards.Suit]);
            boolean = false;
            for i = 1 : length(suits)
                logicalIndices = [hand.Cards.Suit] == suits(i);
                if length(logicalIndices) == 5
                    hand.Flush = hand.Cards(logicalIndices);
                    boolean = true;
                end
            end
        end

        function boolean = isStraight(hand)
            cardValues = hand.Cards.getValues();
            index = strfind(diff(cardValues), ones(1, 4));
            if length(index) == 1
                boolean = true;
                hand.Straight = hand.Cards(index : index + 4);
            elseif (cardValues(end) == 14) & (length(strfind(diff(cardValues), ones(4))) == 1)
                boolean = true;
                logicalIndices = cardValues == 14;
                hand.Cards = circshift(hand.Cards, length(logicalIndices));
                index = strfind(diff(cardValues), ones(1, 4));
                hand.Straight = hand.Cards(index : index + 4);
            else
                boolean = false;
            end
        end
    end
end