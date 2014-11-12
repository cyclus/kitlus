
##### variable setup #####
libname = kitlus
headers = $(wildcard *.h)
source = $(filter-out %_test.cc,$(wildcard *.cc))

##### get default var vals and calc other vars #####
objs = $(source:%.cc=%.o)
soname = lib$(libname).so
postfix = $(libname)

ifeq ($(strip $(CYCLUS_ROOT)),)
ifneq ($(strip $(shell which cyclus)),)
CYCLUS_ROOT = $(strip $(shell cyclus --install-path))
else
CYCLUS_ROOT = $(HOME)/.local
endif
endif

ifeq ($(strip $(PREFIX)),)
	PREFIX = $(HOME)/.local
endif

prefix = $(DESTDIR)/$(PREFIX)
ifeq ($(strip $(DESTDIR)),)
	prefix = $(PREFIX)
endif

LDFLAGS +="-Wl,-rpath,$(CYCLUS_ROOT)/lib,-rpath,$(HOME)/.local/lib"

##### dependency config #####
includes += -I..
includes += -I$(CYCLUS_ROOT)/include/cyclus
includes += -I$(CYCLUS_ROOT)/include/cyclus/toolkit
includes += $(shell export PKG_CONFIG_PATH="$(HOME)/.local/lib/pkgconfig"; pkg-config --cflags sqlite3)
includes += $(shell export PKG_CONFIG_PATH="$(HOME)/.local/lib/pkgconfig"; pkg-config --cflags cbc)
includes += $(shell export PKG_CONFIG_PATH="$(HOME)/.local/lib/pkgconfig"; pkg-config --cflags libxml-2.0)
includes += $(shell export PKG_CONFIG_PATH="$(HOME)/.local/lib/pkgconfig"; pkg-config --cflags libxml++-2.6)
libs += -L$(CYCLUS_ROOT)/lib
libs += -lcyclus

##### primary targets #####
build: $(soname)

debug: CXXFLAGS += -g
debug: $(soname)

release: CXXFLAGS += -O3
release: $(soname)

install: release
	@mkdir -p $(prefix)/lib
	@mkdir -p $(prefix)/include/$(postfix)
	cp $(soname) $(prefix)/lib/
	cp $(headers) $(prefix)/include/$(postfix)/

$(soname) : $(objs)
	@echo "CXX -shared -fpic -rdynamic $(CXXFLAGS) $(CPPFLAGS) $(libs) $(objs) -o $@"
	@$(CXX) -shared -fpic -rdynamic $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(libs) $^ -o $@

clean:
	rm -f *.o *.d *.so

##### pattern rules to build all object files from source #####

# pull in dependency info for *existing* .o files
-include $(objs:%.o=%.d)

%.o : %.cc %.h
	@echo "CXX -c -fpic $(CXXFLAGS) $(CPPFLAGS) $< -o $@"
	@$(CXX) -c -fpic $(CXXFLAGS) $(CPPFLAGS) $(includes) $< -o $@
	@$(CXX) -MM $(CXXFLAGS) $(includes) $< > $*.d

# disable makes built-in implicit rules
.SUFFIXES:
