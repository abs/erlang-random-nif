SOURCE_DIRS=src
VPATH=$(SOURCE_DIRS) # http://www.ipp.mpg.de/~dpc/gmake/make_27.html#SEC26
EBIN_DIR=ebin
LIB_DIR=lib
ET_DIR=et
PREFIX=$(DESTDIR)/usr
RANDOM_NIF_EBIN=lib/erlang/lib/erlang_random_nif-1.0/ebin

CONTRIBS = $(shell echo `ls -d contrib/*/ 2>/dev/null`)
CONTRIB_PATH=$(foreach dir, ${CONTRIBS}, -pa $(dir)ebin)
CONTRIB_INCLUDES=$(foreach dir, ${CONTRIBS}, -I"$(dir)include")

INCLUDE_DIRS=include

INCLUDES=$(foreach dir, $(INCLUDE_DIRS), $(wildcard $(dir)/*.hrl))

INCLUDE_FLAGS += $(foreach dir, $(INCLUDE_DIRS), -I $(dir))

SOURCES=$(foreach dir, $(SOURCE_DIRS), $(wildcard $(dir)/*.erl))
TARGETS=$(foreach dir, $(SOURCE_DIRS), $(patsubst $(dir)/%.erl, $(EBIN_DIR)/%.beam, $(wildcard $(dir)/*.erl))) nif

ERLC_OPTS=$(INCLUDE_FLAGS) $(CONTRIB_INCLUDES) $(CONTRIB_PATH) -o $(EBIN_DIR) -Wall +debug_info # +native -v

MODULES=$(shell echo $(basename $(notdir $(TARGETS))) | sed 's_ _,_g')

all: $(EBIN_DIR) $(LIB_DIR) $(TARGETS)

nif: 
	gcc -fPIC -shared -o $(LIB_DIR)/erlang_random_nif.so.1 c_src/erlang_random_nif.c 

$(EBIN_DIR)/%.beam: %.erl $(INCLUDES)
	erlc $(ERLC_OPTS) $<

$(EBIN_DIR):
	mkdir -p $(EBIN_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

install:
	install -d $(PREFIX)/lib
	install lib/erlang_random_nif.so.1 $(PREFIX)/lib
	cd $(PREFIX)/lib && ln -sf erlang_random_nif.so.1 erlang_random_nif.so
	install -d $(PREFIX)/$(RANDOM_NIF_EBIN)
	install ebin/erlang_random_nif.beam $(PREFIX)/$(RANDOM_NIF_EBIN)

uninstall:
	rm $(PREFIX)/lib/erlang_random_nif.so
	rm $(PREFIX)/lib/erlang_random_nif.so.1
	rm -fr $(PREFIX)/$(RANDOM_NIF_EBIN)
	
clean:
	rm -f ebin/*.beam
	rm -f $(TARGETS)
	rm -fr ebin
