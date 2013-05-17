({
    // the location of all the source files
    appDir: 'build',

    // the path to begin looking for modules. this is relative to appDir
    baseUrl: '.',

    // the directory to write the compiled scripts. this will emulate the
    // directory structure of appDir
    dir: 'dist',

    // explicitly specify the optimization method
    optimize: 'uglify2',

    paths: {
        jquery: 'empty:'
    },

    name: 'fio'
})
