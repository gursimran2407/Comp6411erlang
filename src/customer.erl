%%%-------------------------------------------------------------------
%%% @author gursimransingh
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2019 13:11
%%%-------------------------------------------------------------------
-module(customer).
-author("gursimransingh").

%% API
-export([custListener/5]).


custListener(InitialResource, Resource,BankList, CustomerName, Master)->
  timer:sleep(100),
  receive
    {customerDuty} ->
      if
        (length(BankList) /= 0)  and (Resource > 0)->
         Master! {printmessageCust, self(),{CustomerName,BankList, Resource} },

          RandomBank = lists:nth(rand:uniform(length(BankList)),BankList),
          RandomAmount = rand:uniform(50),
          Pid = whereis(RandomBank),
          timer:sleep(rand:uniform(100) * rand:uniform(10) ),

          Pid ! {loanSanction, {RandomAmount, CustomerName, Master}},
          custListener(InitialResource,Resource,BankList,CustomerName, Master);

        true ->
          if
            (Resource == 0) ->
              Master ! {printmessageCustomerObjectiveReached, {CustomerName, InitialResource}};

            true ->
              Master ! {printmessageCustomerObjectiveNotReached, {CustomerName, Resource}}

          end
      end;



    {loanResult, LoanResult, RandomAmount, BankName, MasterPid} ->


      if
        LoanResult == ok ->
          MasterPid ! {printmessageCustomerLoanApproval, {CustomerName, RandomAmount, BankName} },
          NewResource = (Resource-RandomAmount),

          custListener(InitialResource,NewResource, BankList, CustomerName,Master);

        true ->
          MasterPid ! {printmessageCustomerLoanDeny, {CustomerName, RandomAmount, BankName} },
          NewList = lists:delete(BankName,BankList),
          custListener(InitialResource,Resource, NewList, CustomerName,Master)

      end
  after 2000->
  ok
  end.

