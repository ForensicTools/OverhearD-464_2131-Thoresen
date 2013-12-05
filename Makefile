EXEC = overheard

CC = g++

# Flags
CFLAGS       = -std=c++0x -pthread -lpcap -c
LDFLAGS      = -std=c++0x -pthread -lpcap

# Locations
OUTDIR  = bin
SOURCES = src/overheard.cc src/core/log.cc src/core/ui.cc src/net/host.cc
OBJECTS = $(SOURCES:.cc=.o)
OBJOUT  = $(addprefix $(OUTDIR)/, $(OBJECTS))

# Targets
all: $(SOURCES) $(EXEC)

$(EXEC): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJOUT) -o $(OUTDIR)/$@

.cc.o:
	mkdir -p $(OUTDIR)/$(@D)
	$(CC) $(CFLAGS) $< -o $(OUTDIR)/$@

.PHONY: clean

clean:
	rm -rf $(OUTDIR)/*