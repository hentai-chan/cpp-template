cmake_minimum_required(VERSION 3.3)

project(hello)

set(CCJSON "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")

if (EXISTS "${CCJSON}")
	message(STATUS "Copying ${CCJSON} to project root")
	file(COPY "${CCJSON}" DESTINATION "${PROJECT_SOURCE_DIR}")
endif()

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.*pp")
add_executable(${PROJECT_NAME} ${SOURCES})

target_compile_options(${PROJECT_NAME} PUBLIC -Wall -Wextra)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)
