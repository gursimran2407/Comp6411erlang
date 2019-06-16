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


      {loanSanction, {Amount, CustomerName, MasterPid}} ->
        MasterPid ! {printmessageCustomerLoanRequest, {CustomerName, Amount, BankName}},
        Pid = whereis(CustomerName),
        if
          (Resource>0) and (Resource>Amount)->

            timer:sleep(100),
            Pid ! {loanResult, ok, Amount, BankName, MasterPid},
            Pid ! {customerDuty},
            bankListener(BankName, (Resource-Amount), Master);

            true ->
              Pid !{loanResult, false, Amount, BankName, MasterPid},
              Pid ! {customerDuty},

              bankListener(BankName, Resource, Master)
        end



  after 2000->
    Master ! {printmessageBankDollarsRemaining, {BankName, Resource}}

  end.


  