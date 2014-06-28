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
    env.find(x)[x]
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
  else # procedure call
    exps = x.map {|exp| evaluate(exp, env)}
    proc = exps[0]
    proc.call(*exps[1..-1])
  end
end