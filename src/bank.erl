%%%-------------------------------------------------------------------
%%% @author gursimransingh
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2019 13:12
%%%-------------------------------------------------------------------
-module(bank).
-author("gursimransingh").

%% API
-export([bankListener/2]).


bankListener(BankName, Resource)->
  receive


      {loanSanction, Sender, {Amount, CustomerName}} ->
      masterProcess ! {printmessageCustomerLoanRequest, {CustomerName, Amount, BankName}},

        if
          (Amount < Resource) and (Resource>0) ->
            Pid = whereis(CustomerName),
            timer:sleep(100),
            Pid ! {loanResult, ok, Amount, BankName},
            bankListener(BankName, (Resource-Amount));
          true ->
            bankListener(BankName, Resource)
        end,
    bankListener(BankName, Resource)
  after 2000->
    masterProcess ! {printmessageBankDollarsRemaining, {BankName, Resource}}
end.


  