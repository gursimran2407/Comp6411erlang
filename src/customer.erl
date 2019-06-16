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
-export([custListener/3]).


custListener(Resource,BankList, CustomerName)->
  timer:sleep(100),
  receive
    {customerDuty} ->
      MasterPid = whereis(masterProcess),
      if
        (Resource ==0) and (length(BankList)==0) ->
          MasterPid ! {printmessageCustomerObjectiveReached, {CustomerName, Resource}};
        (length(BankList)==0) ->
          MasterPid ! {printmessageCustomerObjectiveNotReached, {CustomerName, Resource}};

        true ->
          %masterProcess! {printmessageCust, Sender, {CustomerName,BankList, Resource} },
          RandomBank = lists:nth(rand:uniform(length(BankList)),BankList),
          RandomAmount = rand:uniform(50),
          Pid = whereis(RandomBank),
          timer:sleep(rand:uniform(100)),
          Pid ! {loanSanction, {RandomAmount, CustomerName, MasterPid}},
          custListener(Resource,BankList,CustomerName)
          end;

    {loanResult, LoanResult, RandomAmount, BankName} ->
      MasterPid = whereis(masterProcess),

      if
        LoanResult == ok ->
          MasterPid ! {printmessageCustomerLoanApproval, {CustomerName, RandomAmount, BankName} },
          custListener((Resource-RandomAmount), BankList, CustomerName);
        true ->
          MasterPid ! {printmessageCustomerLoanDeny, {CustomerName, RandomAmount, BankName} },
          custListener(Resource, lists:delete(BankName,BankList), CustomerName)
      end,
      custListener(Resource, BankList, CustomerName)
  after 2000->
  ok
  end.

