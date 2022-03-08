classdef Community < handle
    properties
        Cards
    end

    methods 
        function community = Community()
            community.Cards = Card.empty();
        end

        function community = addCard(community, card)
            community.Cards(end + 1) = card;
        end
    end
end