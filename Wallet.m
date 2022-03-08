classdef Wallet < handle
    properties
        Amount
    end

    methods (Static)
        function wallet = Wallet(amount)
            wallet.Amount = amount;

        end

        function wallet = bet(wallet, bet)
            wallet.Amount = wallet.Amount-bet;


            
        end
    end
end