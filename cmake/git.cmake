function(git_get_commit_hash OUTPUT_VAR)
	set(${OUTPUT_VAR} "[unknown]" PARENT_SCOPE)
	execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
		OUTPUT_VARIABLE ${OUTPUT_VAR}
		ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
	)
endfunction()

function(git_update_submodules MSG_TYPE)
	message(STATUS "Updating git submodules...")
	execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
		RESULT_VARIABLE UPDATE_SUBMODULES_RESULT
	)
	if(NOT UPDATE_SUBMODULES_RESULT EQUAL "0")
		message(${MSG_TYPE} "git submodule update failed")
	endif()
endfunction()
