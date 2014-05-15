# Common Makefile Commands
# ------------------------
CC = gcc
RM = rm -rf
INSTALL = install
LN = ln

# Compiler Flags
# --------------
CFLAGS = -Wall

# Target
# ------
# The target executable name.
TARGET = gitflow
ALIAS = gfl

# Directories
# -----------
# As per Makefile conventions, the prefix, exec_prefix, and bindir 
# variables pointing to directories.
prefix = /usr/local
exec_prefix = $(prefix)

bindir = $(exec_prefix)/bin
libdir = $(exec_prefix)/gitflow

tempdir = ./.tmp

# Object Variables
# ----------------
# These varialbes contain references to objects and files used by the 
# compiler and other functions in the Makefile.
LIB_H=
SOURCES=
SCRIPT_SH=
NO_INSTALL=

LIB_H += run_command.h
LIB_H += semver.h
# LIB_H += gitflow-branch.h
# LIB_H += gitflow-feature.h
# LIB_H += gitflow-gh-pages.h
# LIB_H += gitflow-init.h
# LIB_H += gitflow-status.h

SOURCES += gitflow.c
SOURCES += semver.c
SOURCES += run_command.c

OBJECTS = $(addprefix $(tempdir)/,$(notdir $(SOURCES:.c=.o)))

SCRIPT_DIR = ./scripts

SCRIPT_SH += $(SCRIPT_DIR)/feature.sh
SCRIPT_SH += $(SCRIPT_DIR)/gh-pages.sh
SCRIPT_SH += $(SCRIPT_DIR)/init.sh
SCRIPT_SH += $(SCRIPT_DIR)/patch.sh
SCRIPT_SH += $(SCRIPT_DIR)/release.sh

SCRIPT_SH_GEN = $(patsubst %.sh,%,$(SCRIPT_SH))

NO_INSTALL += semver.c

SCRIPT_SH_INS = $(filter-out $(NO_INSTALL),$(SCRIPT_SH_GEN))

.PHONY: all
all: install

# Objects
# -------
# Compiles objects for linking.
$(tempdir)/%.o: %.c $(LIB_H)
	$(CC) -c $< $(CFLAGS) -o $@

# Install
# -------
# In this order, the Makefile creates directories, compiles, and 
# copies scripts to the lib directory. It creates a symbolic link to 
# the program in the bin folder for shell access.
.PHONY: install directories compile copy_scripts
install: | directories compile copy_scripts clean
	
directories:
	-[ -d $(tempdir) ] || mkdir $(tempdir)
	-[ -d $(libdir) ] || mkdir $(libdir)
	-[ -d $(libdir)/scripts ] || mkdir $(libdir)/scripts

compile: $(OBJECTS)
	$(CC) $^ $(CFLAGS) -o $(tempdir)/$(TARGET)
	$(INSTALL) -m 0755 $(tempdir)/$(TARGET) $(libdir)/$(TARGET)

	-[ -e $(bindir)/$(TARGET) ] || $(LN) -s $(libdir)/$(TARGET) $(bindir)/$(TARGET)
	-[ -e $(bindir)/$(ALIAS) ] || $(LN) -s $(libdir)/$(TARGET) $(bindir)/$(ALIAS)

copy_scripts: $(SCRIPT_SH)
	$(INSTALL) -m 0644 $^ $(libdir)/scripts

# Uninstall
# ---------
# Removes all files generated by Makefile. 
# Enumerated: 
# - All files in /usr/local/gitflow
# - gitflow app in 'bin'
# - gitflow alias in 'bin'
.PHONY: uninstall
uninstall:
	$(RM) $(libdir)
	$(RM) $(bindir)/$(TARGET)
	$(RM) $(bindir)/$(ALIAS)

# Clean
# -----
# Removes objects created by Makefile during compile.
.PHONY: clean clean_temp
clean: | clean_temp

clean_temp: $(tempdir)
	$(RM) $^

