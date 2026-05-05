:: Force the 64-bit native toolset (important to avoid "C1060: compiler is out of heap space").
call "%VSINSTALLDIR%VC\Auxiliary\Build\vcvarsall.bat" x64

:: Unset conda-build's automatic CMake variables.
:: This prevents the error:
::   Generator NMake Makefiles does not support platform specification, but platform x64 was specified.
set CMAKE_GENERATOR_PLATFORM=
set CMAKE_GENERATOR_TOOLSET=
set CMAKE_GENERATOR=

:: Use nmake makefiles to force single CPU usage and also provide a clean virtual memory reset
:: for every file (hoping to remove or reduce "C1060: compiler is out of heap space").
set "CMAKE_GENERATOR=NMake Makefiles"

:: Build and install pyGPlates.
::
:: Pip uses the scikit-build-core build backend to compile/install pyGPlates using CMake (see pyproject.toml).
::
:: Note that Boost_ROOT helps avoid finding the Boost library using inherited env var PATH
::      (which can reference a Boost outside of conda). Also, CGAL looks for Boost too.
%PYTHON% -m pip install -vv ^
      -C cmake.define.GPLATES_MSVC_PARALLEL_BUILD=FALSE ^
      -C "cmake.define.CMAKE_PREFIX_PATH=%PREFIX%;%LIBRARY_PREFIX%" ^
      -C "cmake.define.Boost_ROOT=%LIBRARY_PREFIX%" ^
      "%SRC_DIR%"
if errorlevel 1 exit 1
