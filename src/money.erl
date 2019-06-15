%%%-------------------------------------------------------------------
%%% @author gursimransingh
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2019 10:56
%%%-------------------------------------------------------------------
-module(money).
-author("gursimransingh").

%% API
-export([start/0]).

start()->
  CustData = printCustFile(),
  io:fwrite("\n"),
  BankData = printBankFile(),
  runBanks(BankData).


runBanks(BankData)->
  lists:foreach(fun(Element) -> {Bank, Resource} = Element,
  register(Bank, spawn(bank, bankListener, []))
                end,BankData),

  get_feedback().




printBankFile()->
  {ok, BankTxt } = file:consult("banks.txt"),
  io:fwrite("** Banks and financial resources ** ~n"),
  lists:foreach(fun(Element) -> {Bank,Resourse}=Element ,
    {io:fwrite (" ~p:~p ~n", [Bank,Resourse])}
                end,BankTxt),BankTxt.


printCustFile()->
  {ok, CustTxt } = file:consult("customers.txt"),
  io:fwrite("** Customers and loan objectives ** ~n"),
  lists:foreach(fun(Element) -> {Customer,LoanAmount}=Element ,
    {io:fwrite (" ~p:~p ~n", [Customer,LoanAmount])}
                end,CustTxt), CustTxt.




get_feedback() ->
  receive
    {Msg} ->
      io:fwrite("Msg in get_feedback ~s \n\n", [Msg])
  end.