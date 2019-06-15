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
-export([bankListener/0]).


bankListener()->
  receive
    {Sender, Msq} ->
      io:fwrite("Heya ~w",[Msq] ),
      Sender! "Thanks for the message"
  after 2000->
    ok
  end.