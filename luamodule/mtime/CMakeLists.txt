cmake_minimum_required (VERSION 3.9)
project(mtime)

aux_source_directory(. MSRC)
add_library(mtime SHARED ${MSRC})
target_link_libraries(mtime liblua.lib)