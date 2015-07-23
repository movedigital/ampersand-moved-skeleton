'use strict';

# - Modules:
gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
uglify = require 'gulp-uglify'
sourcemaps = require 'gulp-sourcemaps'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
templatizer = require 'templatizer'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
watchify = require 'watchify'
assign = require 'lodash.assign'

browserSync = require('browser-sync').create()
reload = browserSync.reload

# - Configs:
assetsGlob = 'client/assets/**/*.*'
sassGlob = 'client/scss/**/*.scss'
coffeeGlob = 'client/**/*.coffee'
jadeGlob = 'client/**/*.jade'

sassConfig =
  includePaths: [
    './bower_components/foundation/scss'
  ]

vendorScripts = [
  './bower_components/modernizr/modernizr.js'
  './bower_components/jquery/dist/jquery.js'
  './bower_components/fastclick/lib/fastclick.js'
  './bower_components/foundation/js/foundation/foundation.js'
  './bower_components/foundation/js/foundation/foundation.interchange.js'
]

# - Browserify:
browserifyConfig =
  entries: ['./client/app.coffee']
  extensions: ['.coffee', '.js']
  debug: true
  transform: [coffeeify]

browserifyOpts = assign({}, watchify.args, browserifyConfig)
b = watchify( browserify(browserifyOpts) )
b.on 'log', gutil.log

bundle = ->
  return b.bundle()
      .on 'error', gutil.log.bind(gutil, 'Browserify Error')
    .pipe source('app.js')
    .pipe buffer()
    .pipe sourcemaps.init({loadMaps: true})
      .on 'error', gutil.log
    .pipe sourcemaps.write('./')
    .pipe gulp.dest('./public/js')
    .pipe reload({stream: true})

# - Production Tasks:
gulp.task 'default', ['assets', 'sass', 'templatizer', 'js', 'vendorJs']

gulp.task 'assets', ->
  gulp.src assetsGlob
    .pipe gulp.dest('./public')

gulp.task 'sass', ->
  gulp.src sassGlob
    .pipe sass( sassConfig ).on('error', sass.logError)
    .pipe autoprefixer()
    .pipe gulp.dest('./public/css')

gulp.task 'templatizer', ->
  templatizer(__dirname + '/client/templates', __dirname + '/client/templates.js', { jade : { doctype: 'html' } })

gulp.task 'js', ->
  return bundle()

gulp.task 'vendorJs', ->
  gulp.src vendorScripts
    .pipe concat('vendor.js')
    .pipe uglify()
    .pipe gulp.dest('./public/js')

# - Development Tasks:
gulp.task 'dev:assets', ->
  gulp.src assetsGlob
    .pipe gulp.dest('./public')
    .pipe reload({stream: true})

gulp.task 'dev:vendorJs', ->
  gulp.src vendorScripts
    .pipe concat('vendor.js')
      .on 'error', gutil.log
    .pipe gulp.dest('./public/js')

gulp.task 'dev:sass', ->
  gulp.src sassGlob
    .pipe sass( sassConfig )
      .on 'error', (e) ->
        sass.logError(e)
        @emit('end')
    .pipe autoprefixer()
    .pipe gulp.dest('./public/css')
    .pipe browserSync.stream()

gulp.task 'watch', ['dev:assets', 'dev:sass', 'templatizer', 'dev:vendorJs'], ->
  # browserSync.init { port: 80 }
  gulp.watch [sassGlob], ['dev:sass']
  gulp.watch [jadeGlob], ['templatizer']
  gulp.watch [assetsGlob], ['dev:assets']

  bundle()
  b.on('update', bundle)
