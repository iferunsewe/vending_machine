require 'spec_helper'

RSpec.describe Item do
  subject(:item) { described_class.new(name: name, price: price, quantity: quantity) }
  let(:name) { 'Name' }
  let(:price) { 40 }
  let(:quantity) { 5 }

  it 'returns a name' do expect(item.name).to eq(name) end
  it 'returns a price' do expect(item.price).to eq(price) end
  it 'returns a quantity' do expect(item.quantity).to eq(quantity) end
end
