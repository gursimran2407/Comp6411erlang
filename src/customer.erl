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
      Sender! {printmessageCust, Sender, {CustomerName,BankList, Resource} },
      RandomBank = lists:nth(rand:uniform(length(BankList)),BankList),
      RandomAmount = rand:uniform(50),
      Pid = whereis(RandomBank),
      timer:sleep(rand:uniform(10) * rand:uniform(10)),
      Pid ! {loanSanction, self(), {RandomAmount, CustomerName}},
      custListener(Resource,BankList,CustomerName)
  after 2000->
    ok
  end.

