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
-export([custListener/6]).


custListener(InitialResource, Resource,BankList, CustomerName, Master, LoanGathered)->
  timer:sleep(100),
  receive
    {customerDuty} ->

      if
        (length(BankList) /= 0)  and (Resource > 0)->
%%        Master! {printmessageCust, self(),{CustomerName,BankList, Resource} },
          RandomBank = lists:nth(rand:uniform(length(BankList)),BankList),

          RandomAmount = min(rand:uniform(Resource),rand:uniform(50)),
          Pid = whereis(RandomBank),
          timer:sleep(max(rand:uniform(100), rand:uniform(10)) ),

          Pid ! {loanSanction, {RandomAmount, CustomerName}},
          custListener(InitialResource,Resource,BankList,CustomerName, Master,LoanGathered);

        true ->
          if
            (InitialResource == LoanGathered) ->
              Master ! {printmessageCustomerObjectiveReached, {CustomerName, LoanGathered}};

            true ->
              Master ! {printmessageCustomerObjectiveNotReached, {CustomerName, LoanGathered}}

          end
      end;



    {loanResult, LoanResult, RandomAmount, BankName} ->


      if
        LoanResult == true ->
          Master ! {printmessageCustomerLoanApproval, {CustomerName, RandomAmount, BankName} },
          NewResource = (Resource-RandomAmount),
          LoanAmount = RandomAmount+LoanGathered,
          custListener(InitialResource,NewResource, BankList, CustomerName,Master,LoanAmount);

        LoanResult == false ->
          Master ! {printmessageCustomerLoanDeny, {CustomerName, RandomAmount, BankName} },
          NewList = lists:delete(BankName,BankList),
          custListener(InitialResource,Resource, NewList, CustomerName,Master,LoanGathered)

      end
  after 2000->
  ok
  end.

