require 'bundler'
Bundler.require

class Sample
  COLORS = Rainbow::X11ColorNames::NAMES.keys.delete_if do |v|
    [:darkslategray, :black, :white].include? v
  end

  def log(n, msg)
    pid = Process.pid
    tid = Thread.current.object_id
    puts('pid:%s tid:%s [%s] %s' % [
      sprintf('%-7d',  pid).background(:black).foreground(COLORS[pid % COLORS.size]),
      sprintf('%-15d', tid).background(:black).foreground(COLORS[tid % COLORS.size]),
      sprintf('%-6s',    n).background(:black).foreground(COLORS[n.object_id % COLORS.size]),
      msg,
    ])
  end


  def child_eval(r, w)
    log :child, "FD read:#{r.fileno} write:#{w.fileno}"
    log :child, 'Wait the writable io object in a thread'
    sleep 3
    w.puts 'foo'
    w.close
  end

  def parent_eval(r, w, pid)
    log :parent, "child pid: #{pid}"
    log :parent, "FD read:#{r.fileno} write:#{w.fileno}"
    log :parent, "FD write:#{w.closed? ? 'close' : 'open'}"
    sleep 5
    log :parent, "FD write:#{w.closed? ? 'close' : 'open'}"
    log :parent, r.gets
  end

  def pipe_run_with_process
    log :parent, "call #{__method__}"
    r, w = IO.pipe
    pid = Process.fork do
      child_eval(r, w)
    end
    parent_eval(r, w, pid)
  end

  def pipe_run_with_thread
    log :parent, "call #{__method__}"
    r, w = IO.pipe
    Thread.new do
      child_eval(r, w)
    end
    parent_eval(r, w, Process.pid)
  end

end

sample = Sample.new
sample.pipe_run_with_process
#sample.pipe_run_with_thread
#binding.pry

puts 'finish'


