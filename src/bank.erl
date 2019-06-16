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
  timer:sleep(100),
  receive


      {loanSanction, {Amount, CustomerName, MasterPid}} ->
        MasterPid ! {printmessageCustomerLoanRequest, {CustomerName, Amount, BankName}},
        Pid = whereis(CustomerName),
        if
          (Amount < Resource) and (Resource>0) ->

            timer:sleep(100),
            Pid ! {loanResult, ok, Amount, BankName},

            Pid ! {customerDuty},
            bankListener(BankName, (Resource-Amount));

            true ->
              Pid ! {customerDuty},
              Pid !{loanResult, false, Amount, BankName},

              MasterPid ! {printmessageBankDollarsRemaining, {BankName, Resource}}

        end,
        bankListener(BankName, Resource)

  after 2000->
    ok
end.


  