PDIR = ..
PROJECT = lCurses
PROJECTVER = 0.1
PREFIX := $(HOME)/.lua
DATADIR = $(PDIR)/Data
BUILDLIBDIR = $(PDIR)/Build/Library
CC := gcc
DEBUG := 0
CCOPTS := -g -fPIC

LIBNAME = lib`echo $(PROJECT) | tr A-Z a-z`
LIBNAMESO = $(LIBNAME).$(PROJECTVER).so

all: so

so: lcurses.o
	@echo " ==== Building $(LIBNAMESO) Library ===="
	@echo "  --> $(LIBNAMESO) [LD]"
	@$(CC) -g $(CCOPTS) -shared -Wl,-soname,$(LIBNAMESO) -o $(BUILDLIBDIR)/$(LIBNAMESO) lcurses.o

lcurses.o: lcurses.c
	@echo "  --> lcurses.o [CC]"
	@$(CC) $(CCOPTS) -D_DEBUG=$(DEBUG) -c lcurses.c

install: all
	@echo " === Installing $(LIBNAMESO) === "
	@mkdir -p $(PREFIX)/lib/
	@cp $(BUILDLIBDIR)/$(LIBNAMESO) $(PREFIX)/lib

uninstall:
	@echo " === Uninstalling $(LIBNAMESO) === "
	@rm -rf $(PREFIX)/lib/$(LIBNAMESO)

clean:
	@echo " ==== Cleaning C module ==== "
	@rm lcurses.o 2>/dev/null || true
#	@rm $(LIBNAMESO).0.1  2>/dev/null || true
	@rm $(BUILDLIBDIR)/$(LIBNAMESO) 2>/dev/null || true
