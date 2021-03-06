'use strict'
del = require('del')
# server = require('karma').Server
gulp = require('gulp')
gutil = require('gulp-util')
coffee = require('gulp-coffee')
coffeekup = require('gulp-coffeekup')
coffeelint = require('gulp-coffeelint')
concat = require('gulp-concat')
cssmin = require('gulp-cssmin')
gzip = require('gulp-gzip')
# mainBowerFiles = require('gulp-main-bower-files')
tar = require('gulp-tar')
sass = require('gulp-sass')
sassLint = require('gulp-sass-lint')
uglify = require('gulp-uglifyjs')
zip = require('gulp-zip')

# Clean ./dist dir
gulp.task 'clean', ->
  del [
    'dist/index.html'
    'dist/js/vendor/**/*'
    'dist/js/**/*'
    'dist/css/**/*'
  ]
  return

# Lint our coffeescript
gulp.task 'lint', ->
  gulp.src([
    './gulpfile.coffee'
    './src/**/*.coffee'
    './template/**/*.coffee'
  ]).pipe(coffeelint())
  .pipe coffeelint.reporter()
  return

# Compile coffeekup templates
gulp.task 'coffeekup', ->
  gulp.src('./template/**/*.coffee')
  .pipe(coffeekup())
  .pipe gulp.dest('./dist')
  return

gulp.task 'images', ->
  return gulp.src(['./images/**'])
  .pipe(gulp.dest('./dist/images/'))
  return

gulp.task 'sounds', ->
  return gulp.src(['./sounds/**'])
  .pipe(gulp.dest('./dist/sounds/'))
  return

# Game Engine specific
gulp.task 'game-engine-coffee', ->
  gulp.src([
    './src/game_engine/asset_loader.coffee'
    './src/game_engine/math_helpers.coffee',
    './src/game_engine/sprite.coffee',
    './src/game_engine/controller.coffee',
    './src/game_engine/actors/actor.coffee',
    './src/game_engine/actors/square_actor.coffee',
    './src/game_engine/actors/circle_actor.coffee',
    './src/game_engine/tile_map.coffee',
    './src/game_engine/timer.coffee',
    './src/game_engine/stage.coffee',
    './src/game_engine/preloader_stage.coffee',
    './src/game_engine/game_engine.coffee',
  ])
  .pipe(concat('game_engine.coffee'))
  .pipe(coffee(bare: true)
  .on('error', gutil.log))
  .pipe(uglify())
  .pipe gulp.dest('./dist/js')
  return

# Game specific
gulp.task 'game-coffee', ->
  gulp.src([
    './src/game/score.coffee'
    './src/game/effects.coffee',
    './src/game/images.coffee',
    './src/game/stages/split_tile_map.coffee',
    './src/game/stages/split_stage.coffee',
    './src/game/stages/story_stage.coffee',
    './src/game/stages/start_stage.coffee',
    './src/game/stages/game_over_stage.coffee',
    './src/game/actors/monster.coffee',
    './src/game/actors/monster_spawner.coffee',
    './src/game/actors/player.coffee',
    './src/game/actors/left_player.coffee',
    './src/game/actors/right_player.coffee',
    './src/game/actors/bullet.coffee',
  ])
  .pipe(concat('game.coffee'))
  .pipe(coffee(bare: true)
  .on('error', gutil.log))
  .pipe(uglify())
  .pipe gulp.dest('./dist/js')
  return

# Compile coffescript to js
gulp.task 'coffee', ['game-engine-coffee', 'game-coffee']

gulp.task 'vendorjs', ->
  gulp.src('./vendor/*.js')
  .pipe gulp.dest('./dist/js/vendor')
  return

# Compile sass to css
gulp.task 'sass', ->
  gulp.src('./sass/**/*.scss')
  .pipe(sassLint({
    rules: {
      'single-line-per-selector': 0,
      'no-ids': 0,
    }
  }))
  .pipe(sassLint.format())
  .pipe(sassLint.failOnError())
  .pipe(sass.sync()
  .on('error', sass.logError))
  #.pipe(concat('main.css'))
  .pipe(cssmin())
  .pipe gulp.dest('./dist/css')
  return

gulp.task 'watch', ->
  gulp.watch('./src/**/*.coffee', ['lint', 'coffee'])
  gulp.watch('./template/**/*.coffee', ['lint', 'coffeekup'])
  gulp.watch('./sass/**/*.scss', ['sass'])
  return

gulp.task 'compress', ->
  return gulp.src('dist/**/*')
  .pipe(zip('release.zip'))
  .pipe(gulp.dest('.'))

gulp.task 'default', [
  'clean'
  'lint'
  'coffeekup'
  'coffee'
  'sass'
  'images'
  'sounds'
  'watch'
]