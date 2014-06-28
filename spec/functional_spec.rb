require './lib/lisp.rb'

describe 'lisp' do
  it 'tokenizes' do
    tokens = tokenize('(a (+ 3.2 0))')
    expect(tokens).to eq(['(', 'a', '(', '+', '3.2', '0', ')', ')'])
  end

  it 'reads tokens' do
    tree = read(['(', 'define', '(', '+', '3.2', '0', ')', ')'].reverse)
    expect(tree).to eq([:define, [:'+', 3.2, 0]])
  end

  it 'evals variable' do
    env = Env.new([:x], [4])
    expect(evaluate(:x, env)).to eq(4)
  end

  it 'evals constant' do
    expect(evaluate(4)).to eq(4)
  end

  it 'evals quote' do
    exp = [:quote, [:a, 2, 3]]
    expect(evaluate(exp)).to eq([:a, 2, 3])
  end

  it 'evals if then' do
    exp = [:if, true, 1, 2]
    expect(evaluate(exp)).to eq(1)
  end

  it 'evals if else' do
    exp = [:if, false, 1, 2]
    expect(evaluate(exp)).to eq(2)
  end

  it 'evals set!' do
    env = Env.new([:a], [0])
    exp = [:set!, :a, 1]
    evaluate(exp, env)

    expect(evaluate(:a, env)).to eq(1)
  end

  it 'evals define' do
    env = Env.new([], [])
    exp = [:define, :a, 1]
    evaluate(exp, env)

    expect(evaluate(:a, env)).to eq(1)
  end

  it 'evals lambda' do
    env = Env.new([], [])
    exp = [:lambda, [:x], :x]
    lbd = evaluate(exp, env)

    expect(lbd.call(3)).to eq(3)
  end

  it 'evals sequence' do
    env = Env.new([], [])
    exp = [:begin, [:define, :x, 1], [:set!, :x, 2], :x]
    expect(evaluate(exp, env)).to eq(2)
  end

  it 'evals procedure calls' do
    env = Env.new([], [])
    exp = [[:lambda, [:x], :x], 3]
    expect(evaluate(exp, env)).to eq(3)
  end
end