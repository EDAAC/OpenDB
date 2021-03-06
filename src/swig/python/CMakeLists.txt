# Include python
find_package(Python3 COMPONENTS Development REQUIRED)
include_directories(${Python3_INCLUDE_DIRS})

set(OPENDB_PYTHON_SWIG_FILES
    ${PROJECT_SOURCE_DIR}/src/swig/python/opendbpy.i
)

set_source_files_properties(${OPENDB_PYTHON_SWIG_FILES} 
    PROPERTIES CPLUSPLUS ON
)

include_directories(${PROJECT_SOURCE_DIR}/include/opendb)

set(CMAKE_SWIG_FLAGS 
    "-w509,503,501,472,467,402,401,317,325,378,383,389,365,362,314,258,240,203,201")
# Add swig module
swig_add_library(opendbpy 
    TYPE     SHARED
    LANGUAGE python 
    SOURCES  ${OPENDB_PYTHON_SWIG_FILES}
    OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/opendbpy
)
swig_link_libraries(opendbpy
    PUBLIC
        opendb
        Python3::Python
)

set_target_properties( opendbpy
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/opendbpy"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/opendbpy"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/opendbpy"
)

# Configure setup.py and copy to output directory
set(SETUP_PY_IN ${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in)
set(SETUP_PY_OUT ${CMAKE_CURRENT_BINARY_DIR}/setup.py)
configure_file(${SETUP_PY_IN} ${SETUP_PY_OUT})

set(INIT_PY_IN ${CMAKE_CURRENT_SOURCE_DIR}/__init__.py.in)
set(INIT_PY_OUT ${CMAKE_CURRENT_BINARY_DIR}/opendbpy/__init__.py)
configure_file(${INIT_PY_IN} ${INIT_PY_OUT})

# Install target to call setup.py
add_custom_target(install-python
        DEPENDS _opendbpy
        COMMAND python ${SETUP_PY_OUT} install)
