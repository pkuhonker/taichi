message("Using C++ compiler: " ${CMAKE_CXX_COMPILER})

if (TC_DISABLE_SIMD)
    message("SIMD explicitly disabled. This may lead to performance issues.")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_ISE_NONE")
else()
    include(${TAICHI_CMAKE_DIR}/OptimizeForArchitecture.cmake)
    OptimizeForArchitecture()
    message("**************************************************")
    message("* CPU feature detection done.")
    if ("${TARGET_ARCHITECTURE}" MATCHES "sandy-bridge")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_ISE_NONE")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DSANDY_BRIDGE")
        message("* Using Instruction Set Externsion: [None]")
    elseif (USE_AVX2)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_ISE_AVX2")
        message("* Using Instruction Set Externsion: [AVX2]")
    elseif (USE_AVX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_ISE_AVX")
        message("* Using Instruction Set Externsion: [AVX]")
    elseif (USE_SSE4_2)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_ISE_SSE")
        message("* Using Instruction Set Externsion: [SSE]")
    else ()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_ISE_NONE")
        message("* Using Instruction Set Externsion: [None]")
    endif ()
    message("**************************************************")
endif()


if (MINGW)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_hypot=hypot")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DMS_WIN64")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++")
endif ()

if (MSVC)
    link_directories(${CMAKE_CURRENT_SOURCE_DIR}/external/lib)
    set(CMAKE_CXX_FLAGS
            "${CMAKE_CXX_FLAGS} /Zc:__cplusplus /std:c++14 /MP /Z7 /D \"_CRT_SECURE_NO_WARNINGS\" /D \"_ENABLE_EXTENDED_ALIGNED_STORAGE\" /arch:AVX2 -DGL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED")
else()
    if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
        message("Clang compiler detected. Using std=c++17.")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    else()
        message(FATAL_ERROR "clang-7 is the only supported compiler for Taichi compiler development")
    endif()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native -Wall ")
endif ()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_PASS_EXCEPTION_TO_PYTHON")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_INCLUDED")

if ($ENV{TC_USE_DOUBLE})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_USE_DOUBLE")
    message("Using float64 (double) precision as real")
else()
    message("Using float32 (single) precision as real")
endif()

if (TC_USE_MPI)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTC_USE_MPI")
    message("Using MPI")
endif ()

if (NOT WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif()

