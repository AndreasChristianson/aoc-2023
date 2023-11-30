-module('aoc').
-author("sullage").
-export([hello_world/0, day1/0, readlines/1]).
%%-on_load(hello_world/0).

% comment

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

hello_world() ->
  io:fwrite("hello, world\n").

day1() ->
  Lines = readlines("input.txt"),
%%  erlang:display(Lines),
  AsInts = lists:map(
    fun(X) -> AsInt = case X of
                        blank -> blank;
                        S -> {Int, []} = string:to_integer(S), Int
                      end, AsInt
    end,
    Lines
  ),
  MultiLists = split_on_blank(AsInts),
  Sums = sum_groups(MultiLists),
  Max = find_max(Sums),
  erlang:display(Max),
  Max3 = find_max_three(Sums),
  erlang:display(sum_groups(Max3))
.




split_on_blank([]) -> [];
split_on_blank([H | T]) when H == blank ->
  [split_on_blank(T)];
split_on_blank([H | T]) ->
  [H | split_on_blank(T)].

sum_groups(L) -> sum_groups(L, 0).

sum_groups([], Sum) -> [Sum];
sum_groups([H | T], Sum) when not erlang:is_list(H) ->
  sum_groups(T, H + Sum);
sum_groups([H | _], Sum) ->
  [Sum | sum_groups(H)].


find_max(L) -> find_max(L, na).
find_max([], Max) -> Max;
find_max([H | T], Max) when na == Max -> find_max(T, H);
find_max([H | T], Max) when H > Max -> find_max(T, H);
find_max([_ | T], Max) -> find_max(T, Max).

find_max_three(L) -> find_max_three(L, na, na, na).
find_max_three([], Max1, Max2, Max3) -> [Max1, Max2, Max3];
find_max_three([H | T], Max1, Max2, Max3) when na == Max1 -> find_max_three(T, H, Max2, Max3);
find_max_three([H | T], Max1, Max2, Max3) when na == Max2 -> find_max_three(T, Max1, H, Max3);
find_max_three([H | T], Max1, Max2, Max3) when na == Max3 -> find_max_three(T, Max1, Max2, H);
find_max_three([H | T], Max1, Max2, _) when H > Max1 -> find_max_three(T, H, Max1, Max2);
find_max_three([H | T], Max1, Max2, _) when H > Max2 -> find_max_three(T, Max1, H, Max2);
find_max_three([H | T], Max1, Max2, Max3) when H > Max3 -> find_max_three(T, Max1, Max2, H);
find_max_three([_ | T], Max1, Max2, Max3) -> find_max_three(T, Max1, Max2, Max3).
