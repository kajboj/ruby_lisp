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
  elsif x.first == 'quote'
    x.last
  elsif x.first == 'if'
    _, test, conseq, alt = x
    branch = evaluate(test, env) ? conseq : alt
    evaluate(branch, env)
  elsif x.first == 'set!'
    _, name, exp = x
    env.find(name)[name] = evaluate(exp, env)
  end
end