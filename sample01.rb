require 'bundler'
Bundler.require

list = ['a','b','c']

binding.pry

Parallel.map(list) do |one_letter|
  puts one_letter
end

