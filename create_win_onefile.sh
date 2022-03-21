#!/bin/sh

# This should work on Windows (MinGW) and Linux
# for MinGW use e.g. https://gitforwindows.org/

curl -L https://dl.cloudsmith.io/public/ogrecave/ogre/raw/files/ogre-sdk-v13.3.2-msvc141-x64.zip -o ogre-sdk.zip
unzip ogre-sdk.zip

curl -L https://nightly.link/AnotherFoxGuy/ogre/workflows/pip-build/pip/wheel-win.zip -o wheel-win.zip
7z x wheel-win.zip
pip install ogre_python-13.3.3-cp310-cp310-win_amd64.whl

# main
pyinstaller --onefile ogre_mesh_viewer.py

# components
cp bin/OgreMain.dll bin/OgreBites.dll bin/OgreOverlay.dll bin/OgreRTShaderSystem.dll bin/OgreTerrain.dll bin/OgrePaging.dll dist
# plugins
cp bin/Codec*dll bin/RenderSystem*dll bin/Plugin_DotScene.dll dist
# deps
cp bin/SDL2.dll bin/zlib.dll dist

# write plugins.cfg
head -10 bin/plugins.cfg > dist/plugins.cfg
echo Plugin=Codec_STBI >> dist/plugins.cfg
echo Plugin=Codec_Assimp >> dist/plugins.cfg
echo Plugin=Plugin_DotScene >> dist/plugins.cfg

# resources
cp win_resources.cfg dist/resources.cfg
cp -R Media/RTShaderLib Media/Main dist/
cp -R Media/packs/SdkTrays.zip dist/
