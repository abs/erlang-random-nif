-module(test).

-export([run/0, loop/1]).

loop(I) ->
    receive
        {From, stop} ->
            From ! I,
            I;
        continue ->
            erlang_random_nif:random_int(),
            self() ! continue,
            loop(I + 1)
    end.

run() ->
    Pid = spawn(?MODULE, loop, [0]),
    erlang:send_after(5000, Pid, {self(), stop}),
    Pid ! continue,
    receive Msg -> Msg end.
