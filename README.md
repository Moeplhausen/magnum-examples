Here are various examples for Magnum OpenGL 3 engine, demonstrating Magnum
features, usage and capabilities. If you don't know what Magnum is,
see https://github.com/mosra/magnum . Featured examples:

 * **Triangle** - *Hello World* of 3D graphics, displaying triangle with
   interpolated colors.
 * **Textured Triangle** - Loads texture and displays triangle with texture on
   it.
 * **Cube Map** - Loads cube map texture to simulate open world and displays
   two reflecting spheres inside.
 * **Motion Blur** - Moving spheres with motion blur.
 * **Viewer** - Opens and displays COLLADA model.

Each example has its own README, explaining the features and key/mouse
controls, see `src/` subdirectories.

INSTALLATION
============

You can either use packaging scripts, which are stored in package/
subdirectory, or compile and install everything manually. The building
process is similar to Magnum itself - see Magnum documentation for more
comprehensive guide for building, packaging and crosscompiling.

Minimal dependencies
--------------------

 * C++ compiler with good C++11 support. Currently the only compiler which
   supports everything needed is **GCC** >= 4.6. **Clang** >= 3.1 (from SVN)
   will probably work too.
 * **CMake** >= 2.6
 * **OpenGL headers**, on Linux most probably shipped with Mesa
 * **GLEW** - OpenGL extension wrangler
 * **GLUT** - OpenGL utility toolkit
 * **Magnum** - The engine itself
 * **Magnum plugins** - Plugins needed by the examples, you can get them at
   https://github.com/mosra/magnum-plugins

Compilation, installation
-------------------------

The plugins can be built and installed using these four commands:

    mkdir -p build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make
    make install

CONTACT
=======

Want to learn more about the library? Found a bug or want to tell me an
awesome idea? Feel free to visit my website or contact me at:

 * Website - http://mosra.cz/blog/
 * GitHub - https://github.com/mosra/magnum-examples
 * E-mail - mosra@centrum.cz
 * Jabber - mosra@jabbim.cz
