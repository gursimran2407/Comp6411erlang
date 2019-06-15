%%%-------------------------------------------------------------------
%%% @author gursimransingh
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Jun 2019 13:45
%%%-------------------------------------------------------------------
-module(hello).
-author("gursimransingh").

%% API
-export([foo/1,main/0,givemeSSSomeSunshine/0,baz/2]).

-record(name, {key1 = val1, key2 = val2}).
-record(person, {name = unknown, age}).

main() ->
hello_world("Ki haaal Chaal saareya da?"),
 foo({pig,"GONDA",22}).



hello_world(Str) ->
 io:format("~s",[Str]),
 L2 = [14, 12],
 List1 = [144 | L2],
 [TheHead |TheRest] = List1,
 Max = lists:max(List1),
 io:fwrite("Max element in List1 is ~w\n",[Max]),
 io:fwrite("~w\n",[TheHead]),

R1 = #person.age,
 M1 = #{man => "hey", women => "gi"}.

foo({dog, Name})-> io:fwrite("Dog: ~s",[Name]);
foo({cat, Name})-> io:fwrite("Cat: ~s",[Name]);
foo({pig, Name, Weight})-> io:fwrite("Pig: ~s Weight: ~w",[Name,Weight]).

givemeSSSomeSunshine()->
 2/3.

baz(X,P)->

 X*P.