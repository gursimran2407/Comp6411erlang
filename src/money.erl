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
  register(masterProcess, self()),
  CustData = printCustFile(),
  io:fwrite("\n"),
  BankData = printBankFile(),

  BankMap = element(2,file:consult("banks.txt")),
  BankRecords = maps:from_list(BankMap),
  BankMapKeys = maps:keys(BankRecords),
%%  io:fwrite("~w",[BankMapKeys]),
%%  O =isList(BankMapKeys),
%%  io:fwrite("~w",[O]),

  runBanks(BankData),
  runCust(CustData, BankMapKeys).


%%isList(List)->
%%  if
%%  is_list(List)-> true;
%%    true ->
%%      false
%%  end.

runBanks(BankData)->
  lists:foreach(fun(Element) -> {Bank, Resource} = Element,
    Pid = spawn(bank, bankListener, [Bank, Resource, self()]),
    register(Bank, Pid)
                end,BankData),

  get_feedback().


runCust(CustData, BankMapKeys) ->
  lists:foreach(fun(Element) -> {Customer, Resource} = Element,
    Pid = spawn(customer, custListener, [Resource, Resource, BankMapKeys, Customer, self()]),
    register(Customer, Pid),
    Pid ! {customerDuty}
                end,CustData),

  get_feedback().


printBankFile()->
  {ok, BankTxt } = file:consult("banks.txt"),
  io:fwrite("** Banks and financial resources ** ~n"),
  lists:foreach(fun(Element) -> {Bank, Resource} = Element ,
    {io:fwrite (" ~p:~p ~n", [Bank, Resource])}
                end,BankTxt),BankTxt.


printCustFile()->
  {ok, CustTxt } = file:consult("customers.txt"),
  io:fwrite("** Customers and loan objectives ** ~n"),
  lists:foreach(fun(Element) -> {Customer,LoanAmount}=Element ,
    {io:fwrite (" ~p:~p ~n", [Customer,LoanAmount])}
                end,CustTxt), CustTxt.




get_feedback() ->
  receive

    {printmessageCust,  Sender, {Customer,BankData, Resource}} ->
      io:fwrite("Msg in get_feedback : Customer process created Sender: ~w  Customer: ~w Banks: ~w , ResourceCust: ~w\n", [Sender,Customer,BankData, Resource]),
      get_feedback();
    {printmessageCustomerLoanRequest,  {Customer,Amount, BankName}} ->
      io:fwrite(" ~s requests a loan of ~w dollar(s) from ~s\n", [Customer,Amount, BankName]),
      get_feedback();
    {printmessageCustomerLoanApproval,  {Customer,Amount, BankName}} ->
      io:fwrite(" ~s approves a loan of ~w dollar(s) from ~s\n", [BankName,Amount, Customer]),
      get_feedback();
    {printmessageCustomerLoanDeny,  {Customer,Amount, BankName}} ->
      io:fwrite(" ~s denies a loan of ~w dollar(s) from ~s\n", [BankName,Amount, Customer]),
      get_feedback();
%%    {printmessageBank,  Sender, {Bank, Resource}} ->
%%      io:fwrite("Msg in get_feedback : Bank process created Sender: ~w  Bank: ~w , ResourceBank: ~w\n", [Sender,Bank, Resource]),
%%      get_feedback()
    {printmessageCustomerObjectiveReached, {CustomerName,Resource}} ->
      io:fwrite("~s has reached the objective of ~w dollars(s). Woo Hoo! ~n",[CustomerName, Resource]),
      get_feedback();
    {printmessageCustomerObjectiveNotReached,   {CustomerName,Resource}} ->
      io:fwrite("~s was only able to borrow ~w dollars(s). Boo Hoo! ~n",[CustomerName, Resource]),
      get_feedback();
    {printmessageBankDollarsRemaining, {BankName,Resource}} ->
      io:fwrite("~s has ~w dollar(s) remaining. ~n",[BankName, Resource]),
      get_feedback()
  after 500 -> true,
    ok
  end.