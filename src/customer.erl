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
  receive
    {customerDuty, Sender} ->

      if
        (Resource ==0) and (length(BankList)==0) ->
          masterProcess ! {printmessageCustomerObjectiveReached, {CustomerName, Resource}};
        (length(BankList)==0) ->
          masterProcess ! {printmessageCustomerObjectiveNotReached, {CustomerName, Resource}};
        true ->
          ok
          end,


      %masterProcess! {printmessageCust, Sender, {CustomerName,BankList, Resource} },
      RandomBank = lists:nth(rand:uniform(length(BankList)),BankList),
      RandomAmount = rand:uniform(50),
      Pid = whereis(RandomBank),
      timer:sleep(rand:uniform(10) * rand:uniform(10)),
      Pid ! {loanSanction, self(), {RandomAmount, CustomerName}},
      custListener(Resource,BankList,CustomerName);

    {loanResult, LoanResult, RandomAmount, BankName} ->

      if
        LoanResult == ok ->
          masterProcess ! {printmessageCustomerLoanApproval, {CustomerName, RandomAmount, BankName} },
          %self()!{customerDuty,self()},
          custListener((Resource-RandomAmount), BankList, CustomerName);
        true ->
          masterProcess ! {printmessageCustomerLoanDeny, {CustomerName, RandomAmount, BankName} },
          %self()!{customerDuty,self()},
          custListener(Resource, lists:delete(BankName,BankList), CustomerName)
      end,
      custListener(Resource, BankList, CustomerName)
  after 2000->
  ok
  end.

