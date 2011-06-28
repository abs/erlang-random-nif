#include <erl_nif.h>

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

static int load(ErlNifEnv* env, void** priv_data, ERL_NIF_TERM load_info)
{
    srand(time(NULL));
    return 0;
}

static ERL_NIF_TERM random_int(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    return enif_make_int(env, rand());
}

static ERL_NIF_TERM unix_time(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    return enif_make_int(env, time(NULL));
}

static ErlNifFunc nif_funcs[] =
{
    {"random_int", 0, random_int},
    {"unix_time", 0, unix_time}
};

ERL_NIF_INIT(erlang_random_nif, nif_funcs, load, NULL, NULL, NULL)
