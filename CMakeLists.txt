cmake_minimum_required(VERSION 3.3 FATAL_ERROR)

# +++ PROJECT OPTIONS ++++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)								# don't let OPTION erase non-cache variables
set(CMAKE_CXX_EXTENSIONS OFF CACHE INTERNAL "" FORCE) 				# disable compiler extensions
set(CMAKE_POSITION_INDEPENDENT_CODE ON)								# enable PIC flag

# +++ DEFAULT BUILD TYPE +++

# set a default build type if none was given
set(DEFAULT_BUILD_TYPE "Release")
if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
	set(DEFAULT_BUILD_TYPE "Debug")
endif()

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
	message(STATUS "Setting build type to ${DEFAULT_BUILD_TYPE} as none was specified")
	set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
	# set the possible build type values for cmake-gui
	set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# +++ PROJECT PARAMETERS +++
set(PROJECT_NAME hello)
set(IS_ROOT_PROJECT OFF)
set(PROJECT_VERSION "0.0.1.0" CACHE STRING "Application Version" FORCE)
project(${PROJECT_NAME} VERSION "${PROJECT_VERSION}")

# +++ CMAKE INCLUDES +++
include(cmake/git.cmake)

# determines if this is a top-level project
if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
	set(IS_ROOT_PROJECT ON)
endif()

set(CCJSON "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")

find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git")
	# store commit hash
	git_get_commit_hash(${PROJECT_NAME}_GIT_COMMIT_HASH)
	if(IS_ROOT_PROJECT)
		option(GIT_UPDATE_SUBMODULES "Init/Update submodules during generation" ${IS_ROOT_PROJECT})
		if(GIT_UPDATE_SUBMODULES)
			# update and warn on failure
			git_update_submodules(WARNING)
		endif()
	endif()
endif()

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
