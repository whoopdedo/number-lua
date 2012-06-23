LIBNAME = number
LUADIR = /usr/local/share/lua

MKDIR = mkdir -p
INSTALL = install -m 0644
INSTALLBIN = install -m 0755

all: test

test: test.lua lib/script.lua
	$(LUADIR)/lua test.lua

install: lib/script.lua lib/cmdline.lua bin/cmd.lua
	$(MKDIR) $(LUADIR)/$(LIBNAME)
	$(MKDIR) $(BINDIR)
	$(INSTALL) lib/script.lua $(LUADIR)/$(LIBNAME)/script.lua
	$(INSTALL) lib/cmdline.lua $(LUADIR)/$(LIBNAME)/cmdline.lua
	$(INSTALLBIN) bin/cmd.lua $(BINDIR)/number-lua
