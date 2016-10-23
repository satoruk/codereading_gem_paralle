require 'bundler'
Bundler.require
require 'logger'
require './colors'
log = Logger.new(STDOUT)
log.formatter = Colors::COLORIZE_LOG_FORMATTER


log.info('start')
Parallel::UserInterruptHandler.kill_on_ctrl_c([], {}) do
  log.info('start in handler')
  t = Thread.new do
    log.info('start in thread')
    sleep 10
    log.info('end in thread')
  end
  sleep 5
  log.info('thread running in handler')
  t.join
  log.info('thread ran in handler')
  log.info('end in handler')
end
log.info('finish')

