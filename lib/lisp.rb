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