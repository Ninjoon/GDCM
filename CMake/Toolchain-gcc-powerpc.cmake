# http://www.cmake.org/Wiki/CmakeMingw
# Usage:
#
#  $ cmake ../trunk -DCMAKE_TOOLCHAIN_FILE=../trunk/CMake/Toolchain-mingw32.cmake 
#
# For gdcm you need at least the following three package (2008/08/19):
#
#  apt-cross --arch powerpc -i zlib1g-dev
#  apt-cross --arch powerpc -i uuid-dev
#  apt-cross --arch powerpc -i libexpat1-dev
#
# Do not forget to set to on the following:
# GDCM_USE_SYSTEM_EXPAT / GDCM_USE_SYSTEM_ZLIB / GDCM_USE_SYSTEM_UUID

# the name of the target operating system
SET(CMAKE_SYSTEM_NAME Linux)

# which compilers to use for C and C++
SET(CMAKE_C_COMPILER gcc)
#SET(CMAKE_C_FLAGS -mpowerpc)
SET(CMAKE_CXX_COMPILER g++)
#SET(CMAKE_CXX_FLAGS -mpowerpc)

# here is the target environment located
SET(CMAKE_FIND_ROOT_PATH   /usr/powerpc-linux-gnu )

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
