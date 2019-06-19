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
  %register(masterProcess, self()),
  CustData = printCustFile(),
  io:fwrite("\n"),
  BankData = printBankFile(),
  M1 = [],
  M2 = [],
  B1 = [],
  BankMap = element(2,file:consult("banks.txt")),
  BankRecords = maps:from_list(BankMap),
  BankMapKeys = maps:keys(BankRecords),
%%  io:fwrite("~w",[BankMapKeys]),
%%  O =isList(BankMapKeys),
%%  io:fwrite("~w",[O]),

  runBanks(BankData, M1, M2, B1),
  runCust(CustData, BankMapKeys, M1, M2,B1).


%%isList(List)->
%%  if
%%  is_list(List)-> true;
%%    true ->
%%      false
%%  end.

runBanks(BankData, M1, M2, B1)->

  lists:foreach(fun(Element) -> {Bank, Resource} = Element,
    Pid = spawn(bank, bankListener, [Bank, Resource, self()]),
    register(Bank, Pid)
                end,BankData),

  get_feedback(M1, M2, B1).


runCust(CustData, BankMapKeys, M1, M2,B1) ->
  lists:foreach(fun(Element) -> {Customer, Resource} = Element,
    Pid = spawn(customer, custListener, [Resource, Resource, BankMapKeys, Customer, self(),0]),
    register(Customer, Pid),
    Pid ! {customerDuty}
                end,CustData),

  get_feedback(M1, M2,B1).


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




get_feedback(M1, M2, B1) ->
  receive

    {printmessageCust,  Sender, {Customer,BankData, Resource}} ->
      io:fwrite("Msg in get_feedback : Customer process created Sender: ~w  Customer: ~w Banks: ~w , ResourceCust: ~w\n", [Sender,Customer,BankData, Resource]),
      get_feedback(M1, M2, B1);
    {printmessageCustomerLoanRequest,  {Customer,Amount, BankName}} ->
      io:fwrite(" ~s requests a loan of ~w dollar(s) from ~s\n", [Customer,Amount, BankName]),
      get_feedback(M1, M2, B1);
    {printmessageCustomerLoanApproval,  {Customer,Amount, BankName}} ->
      io:fwrite(" ~s approves a loan of ~w dollar(s) from ~s\n", [BankName,Amount, Customer]),
      get_feedback(M1, M2, B1);
    {printmessageCustomerLoanDeny,  {Customer,Amount, BankName}} ->
      io:fwrite(" ~s denies a loan of ~w dollar(s) from ~s\n", [BankName,Amount, Customer]),
      get_feedback(M1, M2, B1);
    {printmessageBank,  {Bank, Resource}} ->
      io:fwrite("Msg in get_feedback : Bank process created Sender:  Bank: ~w , ResourceBank: ~w\n", [Bank, Resource]),
      get_feedback(M1, M2, B1);
    {printmessageCustomerObjectiveReached, {CustomerName,Resource}} ->
      M1New = lists:append(M1, [{CustomerName,Resource}]),
      get_feedback(M1New, M2, B1);
    {printmessageCustomerObjectiveNotReached,   {CustomerName,Resource}} ->
      M2New = lists:append(M2, [{CustomerName,Resource}]),
      get_feedback(M1, M2New, B1);
    {printmessageBankDollarsRemaining, {BankName,Resource}} ->
      B1New = lists:append(B1, [{BankName,Resource}]),
      get_feedback(M1,M2, B1New)
  after 1500 ->
    lists:foreach(fun(Element)-> {Cust, Money} = Element,
      io:fwrite("~s has reached the objective of ~w dollars(s). Woo Hoo! ~n",[Cust, Money])
                  end,M1),
    lists:foreach(fun(Element)-> {Cust, Money} = Element,
      io:fwrite("~s was only able to borrow ~w dollars(s). Boo Hoo! ~n",[Cust, Money])
                  end,M2),
    lists:foreach(fun(Element)-> {Bank, Money} = Element,
      io:fwrite("~s has ~w dollar(s) remaining. ~n",[Bank, Money])
                  end,B1)
      end.