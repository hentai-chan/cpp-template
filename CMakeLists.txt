cmake_minimum_required(VERSION 3.3)

project(hello)

set(CCJSON "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")

if (EXISTS "${CCJSON}")
	message(STATUS "Copying ${CCJSON} to project root")
	file(COPY "${CCJSON}" DESTINATION "${PROJECT_SOURCE_DIR}")
endif()

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.*pp")
add_executable(${PROJECT_NAME} ${SOURCES})

if(CMAKE_CXX_COMPILER_ID STREQUAL Clang OR CMAKE_CXX_COMPILER_ID STREQUAL GNU)
	target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra $<$<NOT:$<CONFIG:Debug>>:-Werror>)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
	target_compile_options(${PROJECT_NAME} PRIVATE $<$<NOT:$<CONFIG:Debug>>:/WX>)
	set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})
endif()

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)
