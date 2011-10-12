PDIR = ..
DATADIR = $(PDIR)/Data
PROJECT = Curses
PREFIX := $(HOME)/.lua
CDIR = $(PDIR)/C
LUADIR = $(PDIR)/Lua
BINDIR = $(PDIR)/Bin
BUILDLIBRARYDIR = $(PDIR)/Build/Library
BUILDSHAREDDIR = $(PDIR)/Build/Shared
CONSTANTSBIN = $(DATADIR)/constants.lua

CONSTANTSDEF = $(DATADIR)/${PROJECT}Constants.def
CONSTANTSC = $(CDIR)/${PROJECT}Constants.c
CONSTANTSLUA = $(LUADIR)/${PROJECT}/Constants.lua
CONSTANTSGEN = $(DATADIR)/${PROJECT}Constants

PROJECTMOD = ${PROJECT}

all: library auxlibraries

library: $(LUADIR)/${PROJECT}/${PROJECT}.lua
	@cp $(LUADIR)/${PROJECT}/${PROJECT}.lua $(BUILDSHAREDDIR)/${PROJECT}

auxlibraries: $(LUADIR)/struct.lua $(LUADIR)/switch.lua
	@echo " ==== Copying lua libraries [LUA] ==== "
	@cp $(LUADIR)/struct.lua $(BUILDSHAREDDIR)/$(PROJECT)
	@cp $(LUADIR)/switch.lua $(BUILDSHAREDDIR)/$(PROJECT)

constants: $(CONSTANTSDEF)
	@echo " ==== Building ${PROJECT} Constants [$(CONSTANTSLUA)] ===="
	@$(CONSTANTSBIN) '$(CONSTANTSDEF)' '$(CONSTANTSC)' '$(CONSTANTSLUA)' '$(PROJECTMOD)'
	@echo "  --> $(CONSTANTSC) [CC]"
	@$(CC) -I$(CDIR) -o $(CONSTANTSGEN) $(CONSTANTSC)
	@echo "  --> $(CONSTANTSLUA) [LUA]"
	@$(CONSTANTSGEN) || true
	@cp $(LUADIR)/${PROJECT}/${PROJECT}.lua $(BUILDSHAREDDIR)/${PROJECT}
	@cp $(LUADIR)/${PROJECT}/Constants.lua $(BUILDSHAREDDIR)/${PROJECT}

install: all
	@echo " == Installing ${PROJECT}.lua == "
	@mkdir -p $(PREFIX)/share/
	@cp -r $(BUILDSHAREDDIR)/${PROJECT} $(PREFIX)/share


uninstall: 
	@echo " == Uninstalling ${PROJECT}.lua == "
	@rm -rf $(PREFIX)/share/${PROJECT}

clean:
	@echo " ==== Cleaning Lua files ==== "
	@rm -rf $(CONSTANTSGEN)
	@rm -rf $(CONSTANTSLUA)
	@rm -rf $(CONSTANTSC)
