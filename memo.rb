in_threads(options) do |worker_num|
  self.worker_number = worker_num
  # as long as there are more jobs, work on one of them
  while !exception && set = job_factory.next
    begin
      item, index = set
      result = with_instrumentation item, index, options do
        call_with_index(item, index, options, &block)
      end
      results_mutex.synchronize { results[index] = result }
    rescue StandardError => e
      exception = e
    end
  end
end
