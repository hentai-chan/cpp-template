cmake_minimum_required(VERSION 3.3 FATAL_ERROR)

# +++ PROJECT OPTIONS ++++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)								# don't let OPTION erase non-cache variables
set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "")						# ensure CMAKE_BUILD_TYPE is non-empty
set(CMAKE_CXX_EXTENSIONS OFF CACHE INTERNAL "" FORCE) 				# disable compiler extensions
set(CMAKE_POSITION_INDEPENDENT_CODE ON)								# enable PIC flag

# +++ PROJECT PARAMETERS +++
set(PROJECT_NAME hello)
set(IS_ROOT_PROJECT OFF)
set(PROJECT_VERSION "0.0.1.0" CACHE STRING "Application Version" FORCE)
project(${PROJECT_NAME} VERSION "${PROJECT_VERSION}")

# determines if this is a top-level project
if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
	set(IS_ROOT_PROJECT ON)
endif()

set(CCJSON "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.[cp]pp")
add_executable(${PROJECT_NAME} ${SOURCES})

if(CMAKE_CXX_COMPILER_ID STREQUAL Clang OR CMAKE_CXX_COMPILER_ID STREQUAL GNU)
	target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra $<$<NOT:$<CONFIG:Debug>>:-Werror>)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
	target_compile_options(${PROJECT_NAME} PRIVATE $<$<NOT:$<CONFIG:Debug>>:/WX>)
	set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})
endif()

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

if(IS_ROOT_PROJECT)
	# copy compile commands
	if(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")
		message(STATUS "Copying compile_commands.json")
		file(COPY "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" DESTINATION "${CMAKE_SOURCE_DIR}")
	endif()
	# lean appveyor build file
	configure_file("${CMAKE_CURRENT_SOURCE_DIR}/.appveyor.yml.in" "${CMAKE_CURRENT_SOURCE_DIR}/.appveyor.yml")
endif()
