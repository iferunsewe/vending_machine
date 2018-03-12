require 'spec_helper'

RSpec.describe Items do
  subject(:items) { described_class.new(stock: stock) }
  let(:stock) { [
    Item.new(name: 'Foo', price: 40, quantity: 5),
    Item.new(name: 'Bar', price: 30, quantity: 8)
  ] }

  it 'returns a stock' do expect(items.stock).to eq(stock) end
end