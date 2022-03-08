classdef Play < handle
    properties
        Balance
        Pocket
        Status
    end

    methods (Static)
        function play = Play(deck, balance)
            play.Balance = Wallet(balance);
            play.Pocket = Pocket(deck.drawCard(), deck.drawCard());
            play.Status = 1;
            
        end

        function play = raise(play)
          
            Amount = 50;
        end
    end
end