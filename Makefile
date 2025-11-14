CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra
LDFLAGS = -lstdc++fs
SOURCES = main.cpp lodepng.cpp
TARGET = mergeFolders

# Release build (optimized)
build: CXXFLAGS += -O2
build: $(TARGET)

# Debug build
debug: CXXFLAGS += -g -O0 -DDEBUG
debug: $(TARGET)

$(TARGET): $(SOURCES)
	$(CXX) $(CXXFLAGS) $(SOURCES) $(LDFLAGS) -o $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: build debug clean

