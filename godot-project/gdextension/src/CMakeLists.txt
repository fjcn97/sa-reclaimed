cmake_minimum_required(VERSION 3.20)
project(sa2_core)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Detect Godot headers - user must set GODOT_HEADERS_DIR or place them in ext/
set(GODOT_HEADERS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../ext/godot-cpp/godot-headers" CACHE PATH "Path to godot-headers")
set(GODOT_CPP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../ext/godot-cpp" CACHE PATH "Path to godot-cpp")

# Godot-cpp library
add_subdirectory(${GODOT_CPP_DIR} godot-cpp)

# Bridge source files
set(SOURCES
    bridge.cpp
)

# Decompiled SA2 core source files (populated in Phase 2)
set(SA2_DECOMP_SOURCES
)

# Godot extension library
add_library(sa2_core SHARED ${SOURCES} ${SA2_DECOMP_SOURCES})
target_include_directories(sa2_core PRIVATE
    ${GODOT_HEADERS_DIR}
    ${GODOT_CPP_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../../include
)

target_link_libraries(sa2_core PRIVATE godot-cpp)

# Output to the bin/ directory
set_target_properties(sa2_core PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../bin"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../bin"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../bin"
)
