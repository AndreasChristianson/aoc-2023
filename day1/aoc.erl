-module('aoc').
-author("sullage").
-export([day1/0]).

readlines(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  try get_all_lines(Device)
  after file:close(Device)
  end.

get_all_lines(Device) ->
  case io:get_line(Device, "") of
    eof -> [];
    "\n" -> [blank | get_all_lines(Device)];
    Line -> [string:trim(Line) | get_all_lines(Device)]
  end.

day1() ->
  Lines = readlines("input.txt"),
  JustNumbers = lists:map(
    fun(X) -> filter_toNumbers(X) end,
    Lines
  ),
  FirstAndLast = lists:map(
    fun(X) -> [first(X), last(X)]
    end,
    JustNumbers
  ),
  erlang:display(lists:sum(lists:flatten(FirstAndLast)))
.

first([H | _]) -> H * 10.

last([H | T]) when T == [] -> H;
last([_ | T]) -> last(T).

filter_toNumbers([]) -> [];
filter_toNumbers([$o,$n,$e| T]) ->[1 | filter_toNumbers([$e|T])];
filter_toNumbers([$t,$w,$o | T]) ->[2 | filter_toNumbers([$o|T])];
filter_toNumbers([$t,$h,$r,$e,$e | T]) ->[3 | filter_toNumbers([$e|T])];
filter_toNumbers([$f,$o,$u,$r | T]) ->[4 | filter_toNumbers(T)];
filter_toNumbers([$f,$i,$v,$e | T]) ->[5 | filter_toNumbers([$e|T])];
filter_toNumbers([$s,$i,$x | T]) ->[6 | filter_toNumbers(T)];
filter_toNumbers([$s,$e,$v,$e,$n | T]) ->[7 | filter_toNumbers([$n|T])];
filter_toNumbers([$e,$i,$g,$h,$t | T]) ->[8 | filter_toNumbers([$t|T])];
filter_toNumbers([$n,$i,$n,$e | T]) ->[9 | filter_toNumbers([$e|T])];
filter_toNumbers([H | T]) ->
  case string:to_integer([H]) of
    {error, no_integer} -> filter_toNumbers(T);
    {N, _} -> [N | filter_toNumbers(T)]
  end.
