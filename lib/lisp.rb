require './lib/env.rb'

def tokenize(s)
  s.gsub(')', ' ) ').gsub('(', ' ( ').split
end

def parse(s)
  read(tokenize(s).reverse)
end 

def read(tokens)
  if tokens.empty?
    raise 'unexpected EOF while reading'
  end

  token = tokens.pop

  if token == '('
    list = []
    while tokens.last != ')' do
      list << read(tokens)
    end
    tokens.pop
    list
  elsif token == ')'
    raise 'unexpected )'
  else
    atom(token)
  end
end

def atom(token)
  Integer(token)
rescue ArgumentError
  begin
    Float(token)
  rescue ArgumentError
    token.to_sym
  end
end

@@global_env = Env.new([], [])

def evaluate(x, env = @@global_env)
  if x.is_a?(Symbol)
    e = env.find(x)
    e ? e[x] : raise("unknown variable #{x}")
  elsif !x.is_a?(Array)
    x
  elsif x.first == :quote
    x.last
  elsif x.first == :if
    _, test, conseq, alt = x
    branch = evaluate(test, env) ? conseq : alt
    evaluate(branch, env)
  elsif x.first == :set!
    _, name, exp = x
    env.find(name)[name] = evaluate(exp, env)
  elsif x.first == :define
    _, name, exp = x
    env[name] = evaluate(exp, env)
  elsif x.first == :lambda
    _, names, exp = x
    lambda do |*vals|
      evaluate(exp, Env.new(names, vals, env)) 
    end
  elsif x.first == :begin
    val = nil
    x[1..-1].each do |exp|
      val = evaluate(exp, env)
    end
    val
  elsif x.first == :load
    _, filename = x
    code = File.read(filename.to_s)
    evaluate(parse(code))
  else # procedure call
    exps = x.map {|exp| evaluate(exp, env)}
    proc = exps[0]
    proc.call(*exps[1..-1])
  end
end

def add_globals(env)
  %w(+ - * /).map(&:to_sym).each do |op|
    env[op] = lambda {|*args| args.reduce(op)}
  end

  %w(< <= > >= equal? eql?).map(&:to_sym).each do |op|
    env[op] = lambda {|a, b| a.send(op, b)}
  end

  env[:length] = lambda {|l| l.length}
  env[:cons] = lambda {|x, y| [x]+y}
  env[:car] = lambda {|x| x.first}
  env[:cdr] = lambda {|x| x[1..-1]}
  env[:append] = lambda {|x, y| x + y}
  env[:list] = lambda {|*x| x}
  env[:list?] = lambda {|x| x.is_a?(Array)}
  env[:symbol?] = lambda {|x| x.is_a?(Symbol)}
  env[:null?] = lambda {|x| x == []}
end

def to_string(exp)
  if exp.is_a?(Array)
    '(' + exp.map do |exp|
      to_string(exp)
    end.join(' ') + ')'
  else
    exp.to_s
  end
end

def repl
  while true do
    print('ruby_lisp> ')
    begin
      val = evaluate(parse(readline))
    rescue Exception => e
      exit(0) if e.is_a?(Interrupt)
    end
    puts to_string(val)
    puts e
  end
end

add_globals(@@global_env)