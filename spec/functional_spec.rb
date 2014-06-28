require './lib/lisp.rb'

describe 'lisp' do
  it 'tokenizes' do
    tokens = tokenize('(a (+ 3.2 0))')
    expect(tokens).to eq(['(', 'a', '(', '+', '3.2', '0', ')', ')'])
  end

  it 'reads tokens' do
    tree = read(['(', 'a', '(', '+', '3.2', '0', ')', ')'].reverse)
    expect(tree).to eq([:a, [:'+', 3.2, 0]])
  end
end