SOURCES := $(shell find APL_code/ -type file)
DYALOG := dyalog

pnm.dws: $(SOURCES)
	$(DYALOG) CONFIGFILE=build.dcfg
