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
  MasterPID = self(),
  register(master, MasterPID ),
  runBanks(BankData),
  runCust(CustData, BankData).


runBanks(BankData)->
  lists:foreach(fun(Element) -> {Bank, Resource} = Element,
    Pid = spawn(bank, bankListener, []),
    register(Bank, Pid),
    Pid ! {bankDuty, self(), {Resource}}
                end,BankData),

  get_feedback().


runCust(CustData, BankData)->
  lists:foreach(fun(Element) -> {Customer, Resource} = Element,
    Pid = spawn(customer, custListener, []),
    register(Customer, Pid),
    Pid ! {customerDuty, self(), {Customer,BankData, Resource}}
                end,CustData),

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
    {printmessage, Msg} ->
      io:fwrite("Msg in get_feedback ~s \n", [Msg]),
      get_feedback();
    {printmessageCust,  Sender, {Customer,BankData, Resource}} ->
      io:fwrite("Msg in get_feedback : Customer process created Sender: ~w  Customer: ~w Banks: ~w , ResourceCust: ~w\n", [Sender,Customer,BankData, Resource]),
      get_feedback()
  after 1500 -> true,
    io:fwrite ("~s~n", ["Master has received no reply for 1.5 seconds, ending...." ])
  end.