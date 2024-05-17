SOURCES := $(shell find APL_code/ -type file)
DYALOG := /Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/dyalog

pnm.dws: $(SOURCES)
	$(DYALOG) CONFIGFILE=build.dcfg
