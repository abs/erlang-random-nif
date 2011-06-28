-module(erlang_random_nif).

-on_load(init/0).

-export([init/0, init/1]).

-export([
    random_int/0,
    unix_time/0
    ]).

-define(MAXINT, 479001600).

init() ->
    case filelib:is_regular("/usr/lib/erlang_random_nif.so") of
        true ->
            erlang:load_nif("/usr/lib/erlang_random_nif", 0);
        false ->
            error_logger:info_msg("/usr/lib/erlang_random_nif.so not found, defaulting to native version.\n"),
            ok
    end.

init(NifPath) ->
    erlang:load_nif(NifPath, 0).

random_int() ->
    {A1, A2, A3} = now(),
    random:seed(A1, A2, A3),
    random:uniform(?MAXINT).

unix_time() ->
    calendar:datetime_to_gregorian_seconds(
        calendar:universal_time()) -
            calendar:datetime_to_gregorian_seconds(
                {{1970, 1, 1}, {0, 0, 0}}). 
