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
-export([bankListener/3]).


bankListener(BankName, Resource, Master)->
  timer:sleep(100),
  receive


      {loanSanction, {Amount, CustomerName}} ->
        Master! {printmessageCustomerLoanRequest, {CustomerName, Amount, BankName}},
        Pid = whereis(CustomerName),
        Master ! {printmessageBank,[{BankName, Resource}]}
        ,
        if
          (Resource>=0) and (Amount < Resource)->

            timer:sleep(100),
            Pid ! {loanResult, true, Amount, BankName},
            Pid ! {customerDuty},
            bankListener(BankName, (Resource-Amount), Master);

          true ->
              Pid !{loanResult, false, Amount, BankName},
              Pid ! {customerDuty},
              bankListener(BankName, Resource, Master)
        end



  after 4000->
  Master ! {printmessageBankDollarsRemaining, {BankName, Resource}}
  end.


  