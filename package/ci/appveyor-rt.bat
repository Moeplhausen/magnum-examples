call "C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/vcvarsall.bat" x64 || exit /b
set PATH=%APPVEYOR_BUILD_FOLDER%\deps-native\bin;%PATH%

rem Build ANGLE
git clone --depth 1 git://github.com/MSOpenTech/angle.git || exit /b
cd angle\winrt\10\src || exit /b
msbuild angle.sln /p:Configuration=Release || exit /b
cd ..\..\..\.. || exit /b

rem Build SDL
appveyor DownloadFile https://www.libsdl.org/release/SDL2-2.0.4.zip || exit /b
7z x SDL2-2.0.4.zip || exit /b
ren SDL2-2.0.4 SDL || exit /b
cd SDL/VisualC-WinRT/UWP_VS2015 || exit/b
msbuild /p:Configuration=Release || exit /b
cd ..\..\..

git clone --depth 1 git://github.com/mosra/corrade.git || exit /b
cd corrade || exit /b

rem Build native corrade-rc
mkdir build && cd build || exit /b
cmake .. ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%APPVEYOR_BUILD_FOLDER%/deps-native ^
    -DWITH_INTERCONNECT=OFF ^
    -DWITH_PLUGINMANAGER=OFF ^
    -DWITH_TESTSUITE=OFF ^
    -G Ninja || exit /b
cmake --build . --target install || exit /b
cd .. || exit /b

rem Crosscompile Corrade
mkdir build-rt && cd build-rt || exit /b
cmake .. ^
    -DCMAKE_SYSTEM_NAME=WindowsStore ^
    -DCMAKE_SYSTEM_VERSION=10.0 ^
    -DCORRADE_RC_EXECUTABLE=%APPVEYOR_BUILD_FOLDER%/deps-native/bin/corrade-rc.exe ^
    -DCMAKE_INSTALL_PREFIX=%APPVEYOR_BUILD_FOLDER%/deps ^
    -DWITH_INTERCONNECT=OFF ^
    -DBUILD_STATIC=ON ^
    -G "Visual Studio 14 2015" -A x64 || exit /b
cmake --build . --config Release --target install -- /m /v:m || exit /b
cd .. && cd ..

rem Crosscompile Magnum
git clone --depth 1 git://github.com/mosra/magnum.git || exit /b
cd magnum || exit /b
mkdir build-rt && cd build-rt || exit /b
cmake .. ^
    -DCMAKE_SYSTEM_NAME=WindowsStore ^
    -DCMAKE_SYSTEM_VERSION=10.0 ^
    -DCORRADE_RC_EXECUTABLE=%APPVEYOR_BUILD_FOLDER%/deps-native/bin/corrade-rc.exe ^
    -DCMAKE_PREFIX_PATH=%APPVEYOR_BUILD_FOLDER%/deps ^
    -DCMAKE_INSTALL_PREFIX=%APPVEYOR_BUILD_FOLDER%/deps ^
    -DEGL_LIBRARY=%APPVEYOR_BUILD_FOLDER%/angle/winrt/10/src/Release_x64/lib/libEGL.lib ^
    -DEGL_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/angle/include ^
    -DOPENGLES2_LIBRARY=%APPVEYOR_BUILD_FOLDER%/angle/winrt/10/src/Release_x64/lib/libGLESv2.lib ^
    -DOPENGLES2_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/angle/include ^
    -DOPENGLES3_LIBRARY=%APPVEYOR_BUILD_FOLDER%/angle/winrt/10/src/Release_x64/lib/libGLESv2.lib ^
    -DOPENGLES3_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/angle/include ^
    -DSDL2_LIBRARY=%APPVEYOR_BUILD_FOLDER%/SDL/VisualC-WinRT/UWP_VS2015/X64/Release/SDL-UWP/SDL2.lib ^
    -DSDL2_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/SDL/include ^
    -DWITH_AUDIO=OFF ^
    -DWITH_DEBUGTOOLS=OFF ^
    -DWITH_MESHTOOLS=OFF ^
    -DWITH_PRIMITIVES=OFF ^
    -DWITH_SCENEGRAPH=OFF ^
    -DWITH_SHADERS=OFF ^
    -DWITH_SHAPES=OFF ^
    -DWITH_TEXT=OFF ^
    -DWITH_TEXTURETOOLS=OFF ^
    -DWITH_SDL2APPLICATION=ON ^
    -DTARGET_GLES2=%TARGET_GLES2% ^
    -DBUILD_STATIC=ON ^
    -G "Visual Studio 14 2015" -A x64 || exit /b
cmake --build . --config Release --target install -- /m /v:m || exit /b
cd .. && cd ..

rem Crosscompile Magnum Integration
git clone --depth 1 git://github.com/mosra/magnum-integration.git || exit /b
cd magnum-integration || exit /b
mkdir build-rt && cd build-rt || exit /b
cmake .. ^
    -DCMAKE_SYSTEM_NAME=WindowsStore ^
    -DCMAKE_SYSTEM_VERSION=10.0 ^
    -DCORRADE_RC_EXECUTABLE=%APPVEYOR_BUILD_FOLDER%/deps-native/bin/corrade-rc.exe ^
    -DCMAKE_PREFIX_PATH=%APPVEYOR_BUILD_FOLDER%/deps ^
    -DCMAKE_INSTALL_PREFIX=%APPVEYOR_BUILD_FOLDER%/deps ^
    -DOPENGLES2_LIBRARY=%APPVEYOR_BUILD_FOLDER%/angle/winrt/10/src/Release_x64/lib/libGLESv2.lib ^
    -DOPENGLES2_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/angle/include ^
    -DOPENGLES3_LIBRARY=%APPVEYOR_BUILD_FOLDER%/angle/winrt/10/src/Release_x64/lib/libGLESv2.lib ^
    -DOPENGLES3_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/angle/include ^
    -DWITH_BULLET=OFF ^
    -DWITH_OVR=OFF ^
    -G "Visual Studio 14 2015" -A x64 || exit /b
cmake --build . --config Release --target install -- /m /v:m || exit /b
cd .. && cd ..

rem Crosscompile
mkdir build-rt && cd build-rt || exit /b
cmake .. ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH=%APPVEYOR_BUILD_FOLDER%/deps ^
    -DOPENGLES2_LIBRARY=%APPVEYOR_BUILD_FOLDER%/angle/winrt/10/src/Release_x64/lib/libGLESv2.lib ^
    -DOPENGLES2_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/angle/include ^
    -DOPENGLES3_LIBRARY=%APPVEYOR_BUILD_FOLDER%/angle/winrt/10/src/Release_x64/lib/libGLESv2.lib ^
    -DOPENGLES3_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/angle/include ^
    -DSDL2_LIBRARY=%APPVEYOR_BUILD_FOLDER%/SDL/VisualC-WinRT/UWP_VS2015/X64/Release/SDL-UWP/SDL2.lib ^
    -DSDL2_INCLUDE_DIR=%APPVEYOR_BUILD_FOLDER%/SDL/include ^
    -DWITH_AUDIO_EXAMPLE=OFF ^
    -DWITH_BULLET_EXAMPLE=OFF ^
    -DWITH_CUBEMAP_EXAMPLE=OFF ^
    -DWITH_MOTIONBLUR_EXAMPLE=OFF ^
    -DWITH_OVR_EXAMPLE=OFF ^
    -DWITH_PICKING_EXAMPLE=OFF ^
    -DWITH_PRIMITIVES_EXAMPLE=OFF ^
    -DWITH_SHADOWS_EXAMPLE=OFF ^
    -DWITH_TEXT_EXAMPLE=OFF ^
    -DWITH_TEXTUREDTRIANGLE_EXAMPLE=OFF ^
    -DWITH_TRIANGLE_EXAMPLE=OFF ^
    -DWITH_VIEWER_EXAMPLE=OFF ^
    -G "Visual Studio 14 2015" -A x64 || exit /b
cmake --build . --config Release -- /m /v:m || exit /b
