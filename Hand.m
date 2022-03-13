classdef Hand < handle
    properties
        Cards
        Matching
        Straight
        Flush
        MatchingIndices
        MatchingScores
        Ranking
        Scores
    end
    
    methods
        % When calling function, use "Hand(pocket.Cards, community.Cards);"
        function hand = Hand(pocket, community)
            hand.Cards = hand.sortCards([pocket, community]);
            hand.Ranking = hand.getRanking();
        end

        function ranking = getRanking(hand)
            matchingCards = hand.getMatchingCards();
            if hand.isStraight()
                if isequal(hand.Flush, hand.Straight)
                    ranking = 2;
                else
                    ranking = 6;
                end
                hand.Scores = hand.Straight(5).getValues();
            elseif hand.isFlush()
                ranking = 5;
                hand.Scores = hand.Flush(5).getValues();
            else
                pairScore = 0;
                pairScore2 = 0;
                threeScore = 0;
                for i = 1 : length(matchingCards)
                    if length(matchingCards{i}) == 4
                        ranking = 3;
                        hand.Scores = [max(matchingCards{i}.getValues()), hand.getHighestValues(matchingCards{i}, 1)];
                        return;
                    elseif length(matchingCards{i}) == 3 && (max(matchingCards{i}.getValues()) > threeScore)
                        if threeScore > pairScore
                            pairScore = threeScore;
                        end
                        threeScore = max(matchingCards{i}.getValues());
                    elseif (length(matchingCards{i}) == 2) && (max(matchingCards{i}.getValues()) > pairScore)
                        pairScore2 = pairScore;
                        pairScore = max(matchingCards{i}.getValues());
                    end
                end
                if threeScore > 0
                    if pairScore > 0
                        ranking = 4;
                        hand.Scores = [threeScore, pairScore];
                    else
                        ranking = 7;
                        hand.Scores = [threeScore, hand.getHighestValues(matchingCards{1}, 2)];
                    end
                elseif pairScore > 0
                    if length(matchingCards) >= 2
                        ranking = 8;
                        hand.Scores = [pairScore, pairScore2, hand.getHighestValues([matchingCards{:}], 1)];
                    else
                        ranking = 9;
                        hand.Scores = [pairScore, hand.getHighestValues(matchingCards{1}, 3)];
                    end
                else
                    ranking = 10;
                    hand.Scores = [hand.getHighestValues([], 5)];
                end
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
            hand.MatchingIndices = double.empty();
            numberMatching = 0;
            index = 2;
            while index <= handSize
                if logicalIndices(index) == 1
                    logicalIndices(index - 1) = 1;
                    numberMatching = numberMatching + 1;
                    hand.MatchingIndices(numberMatching) = index - 1;
                    index = index + 1;
                end
                index = index + 1;
            end
            matchingCards = cell.empty();
            for i = 1 : numberMatching - 1
                leftPadding = zeros(1, hand.MatchingIndices(i) - 1);
                matchingCardsIndices = logicalIndices(hand.MatchingIndices(i) : hand.MatchingIndices(i + 1) - 1);
                rightPadding = zeros(1, handSize - hand.MatchingIndices(i + 1) + 1);
                currentLogicalIndices = [leftPadding, matchingCardsIndices, rightPadding];
                matchingCards{i} = hand.Cards(logical(currentLogicalIndices));
            end
            if ~isempty(hand.MatchingIndices)
                matchingCardsIndices = logicalIndices(hand.MatchingIndices(end) : end);
                currentLogicalIndices = [zeros(1, hand.MatchingIndices(end) - 1), matchingCardsIndices];
                matchingCards{end + 1} = hand.Cards(logical(currentLogicalIndices));
                hand.Matching = matchingCards;
                for i = 1 : numberMatching
                    hand.MatchingScores(end + 1) = sum(matchingCards{i}.getValues());
                end
            end
        end

        function values = getHighestValues(hand, excludedCards, numberCards)
            cards = hand.Cards;
            if ~isempty(excludedCards)
                for i = length(hand.Cards) : -1 : 1
                    if sum(excludedCards.isEqual(hand.Cards(i))) > 0
                        cards(i) = [];
                    end
                end
            end
            values = cards.getValues();
            values = values(end : -1 : end - numberCards + 1);
        end

        function boolean = isFlush(hand)
            suits = unique([hand.Cards.Suit]);
            boolean = false;
            for i = 1 : length(suits)
                logicalIndices = [hand.Cards.Suit] == suits(i);
                if sum(logicalIndices) >= 5
                    hand.Flush = hand.Cards(logicalIndices);
                    boolean = true;
                end
            end
        end

        function boolean = isStraight(hand)
            if hand.isFlush()
                cards = hand.Flush;
            else 
                cards = hand.Cards;
                for i = length(hand.MatchingIndices) : -1 : 1
                    index = hand.MatchingIndices(i);
                    cards(index + 1 : index + length(hand.Matching{i}) - 1) = [];
                end
            end
            cardValues = cards.getValues();
            if length(strfind(diff(cardValues), ones(1, 4))) == 1
                boolean = true;
                hand.Straight = cards;
            elseif (cardValues(end) == 14) && (length(strfind(diff(cardValues), ones(1, 4))) == 1)
                boolean = true;
                cards = circshift(cards, 1);
                hand.Straight = cards;
            else
                boolean = false;
            end
        end

        function boolean = isGreater(hand1, hand2)
            for i = 1 : length(hand1.Scores)
                if hand1.Scores(i) > hand2.Scores(i)
                    boolean = true;
                    return;
                end
            end
            boolean = false;
        end
    end
end