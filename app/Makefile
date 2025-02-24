# Define variables
CXX = g++  # The C++ compiler to use
CXXFLAGS = -I/usr/include/opencv4 -Wall  # Include directories for dependencies

# List of source files and output file
SRC = counter_people.cpp  # Source code file
BIN = counter_people  # The output binary (executable)

# Default target (first target in Makefile)
all: $(BIN)

# Rule for compiling the binary
$(BIN): $(SRC)
	$(CXX) $(SRC) -o $(BIN) $(CXXFLAGS)

# Clean rule to remove generated files
clean:
	rm -f $(BIN)

