#! /usr/bin/env ruby
require './lib/lisp.rb'

start_filename = 'start.lisp'
if File.exists?(start_filename)
  evaluate(parse("(load #{start_filename})"))
end

repl