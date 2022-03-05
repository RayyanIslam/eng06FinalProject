classdef Pocket
    properties
        Cards
    end

    methods
        function pocket = Pocket(card1, card2)
            pocket.Cards = [card1, card2];
        end
    end
end