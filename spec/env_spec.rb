require './lib/env.rb'

describe 'env' do
  specify do
    outer = Env.new([:a, :b], [1, 2])
    inner = Env.new([:b, :c], [3, 4], outer)

    expect(outer.find(:a)).to eq(outer)
    expect(outer.find(:b)).to eq(outer)

    expect(inner.find(:a)).to eq(outer)
    expect(inner.find(:b)).to eq(inner)
    expect(inner.find(:c)).to eq(inner)

    expect(outer.find(:x)).to be_nil
    expect(inner.find(:x)).to be_nil
  end
end