require 'bundler'
Bundler.require

class Sample
  def worker_number
    Thread.current[:parallel_worker_number]
  end

  def worker_number=(worker_num)
    puts "worker_number=(#{worker_num})"
    Thread.current[:parallel_worker_number] = worker_num
  end

  def run
    pid = Process.fork do
      self.worker_number = 100
    end
    puts pid
  end

  def pipe_run_with_process
    r, w = IO.pipe
    pid = Process.fork do
      puts "[child]pid: #{Process.pid}"
      puts "[child] FD read:#{r.fileno} write:#{w.fileno}"
      puts 'Wait the writable io object in a thread'
      sleep 3
      w.puts 'foo'
      w.close
    end
    puts "[parent]parent pid: #{Process.pid}"
    puts "[parent]child pid: #{pid}"
    puts "[parent] FD read:#{r.fileno} write:#{w.fileno}"
    puts "[parent] FD read:#{w.closed? ? 'close' : 'open'}"
    puts r.gets
  end

  def pipe_run_with_thread
    r, w = IO.pipe
    p [r, w] #=> [#<IO:fd 7>, #<IO:fd 8>]
    Thread.new do
      puts 'Wait the writable io object in a thread'
      sleep 3
      w.puts 'foo'
      w.close
    end
    puts r.gets
  end

end

sample = Sample.new
sample.pipe_run_with_process
#binding.pry

puts 'finish'


