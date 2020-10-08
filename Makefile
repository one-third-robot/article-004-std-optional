
# =============================================================================
EXEC      = sensor-read
CODE_PATH = .
LIBS      = -lm
LIBS     += -I/usr/local/lib/
OUTPATH   = bin
OPT       = -Og -O0
CC        = g++-10
CPPSTD    = -std=c++17
MTYPE_ALL = RELEASE
$(info )
$(info ------------------------------------)
$(info LIBS:)
$(info  $(LIBS))

# =============================================================================
AS = $(CC) -x assembler-with-cpp
CP = objcopy
SZ = size

# =============================================================================
# collect '.cpp' file to SRCS
DIRS := $(shell find $(CODE_PATH) -maxdepth 10 -type d)
SRCS  = $(foreach dir,$(DIRS),$(wildcard $(dir)/*.cpp))
$(info )
$(info ------------------------------------)
$(info source files:)
$(info  $(SRCS))

OBJS     = $(addprefix $(OUTPATH)/,$(notdir $(SRCS:.cpp=.o)))
vpath %.cpp $(sort $(dir $(SRCS)))
$(info )
$(info ------------------------------------)
$(info object files:)
$(info  $(OBJS))

# collect '.h' files in INC
INCH = $(foreach dir,$(DIRS),$(wildcard $(dir)/*.h))
INC  = $(shell find -L $(INCH) -name '*.h' -exec dirname {} \; | uniq)
$(info )
$(info ------------------------------------)
$(info headers to include:)
$(info  $(INC:%=-I%))

$(info )
$(info ====================================)
$(info )

# =============================================================================
CFLAGS    = $(C_DEFS) $(INC:%=-I%) $(OPT)
# treat all warnings as errors
CFLAGS  += -Werror=unused-parameter
HOSTFLAGS = $(CPPSTD) $(LIBS)

# =============================================================================
.PHONY: all
all: CFLAGS+= -D MAKE_TYPE=\"$(MTYPE_ALL)\"
all: CFLAGS+= $(HOSTFLAGS)
all: $(OBJS)
	$(CC) -o $(OUTPATH)/$(EXEC) $(OBJS) $(CFLAGS)
	$(SZ) $(OUTPATH)/$(EXEC)

$(OUTPATH)/%.o: %.cpp | $(OUTPATH)
	$(CC) -c $(CFLAGS) $< -o $@

$(OUTPATH):
	mkdir -p $@

# ------------------------------------------------
clean:
	rm -f $(OUTPATH)/*
