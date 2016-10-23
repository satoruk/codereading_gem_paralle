require 'bundler'
Bundler.require
require 'logger'
require './colors'
log = Logger.new(STDOUT)
log.formatter = Colors::COLORIZE_LOG_FORMATTER

list = ['a','b','c']
log.info 'start'
Parallel.map(list, in_processes: 2) do |one_letter|
    log.info one_letter
end
log.info 'finish'
