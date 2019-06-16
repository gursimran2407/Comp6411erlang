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

      {bankDuty, Sender} ->
      Sender! {printmessageBank, Sender,{BankName, Resource}},
        bankListener(BankName, Resource);

      {loanSanction, Sender, {Amount, CustomerName}} ->
      masterProcess ! {printmessageCustomerLoanRequest,Sender, {CustomerName, Amount, BankName}},
      bankListener(BankName, Resource)
  after 2000->
    ok
  end.


loanDecision(LoanAmount, BankResource) ->
  if
    LoanAmount =< BankResource ->
      true
    ;
    true ->
      false
  end.
  