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
-export([custListener/0]).


custListener()->
  receive
    { printGeneralMessage, Sender, Msq} ->
      master! {printmessage, [Msq]},
      custListener();
    {customerDuty, Sender, {Customer,BankData, Resource}} ->
      master! {printmessageCust, Sender, {Customer,BankData, Resource} }
  after 2000->
    ok
  end.
