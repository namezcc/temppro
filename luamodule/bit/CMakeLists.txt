cmake_minimum_required (VERSION 3.9)
project(mbit)

aux_source_directory(. MSRC)
add_library(mbit SHARED ${MSRC})
target_link_libraries(mbit liblua.lib)