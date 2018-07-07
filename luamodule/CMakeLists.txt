cmake_minimum_required (VERSION 3.9)
project (Lua)

include_directories(${PROJECT_SOURCE_DIR}/src/ 
${PROJECT_SOURCE_DIR}/mtime/ 
)

file(GLOB_RECURSE luasrc ${PROJECT_SOURCE_DIR}/src/*.h ${PROJECT_SOURCE_DIR}/src/*.c)

add_definitions(
-DLUA_BUILD_AS_DLL
)

link_directories(
	${PROJECT_SOURCE_DIR}/build/ 
)

add_library(liblua SHARED ${luasrc})

add_executable(lua lua.c)
target_link_libraries(lua liblua.lib)

add_subdirectory(mtime)
add_subdirectory(bit)
#add_executable(luac luac.c)
#target_link_libraries(luac liblua.lib)