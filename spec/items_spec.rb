require 'spec_helper'

RSpec.describe Items do
  subject(:items) { described_class.new(stock: stock) }
  let(:stock) { [
    Item.new(name: 'Foo', price: 40, quantity: 5),
    Item.new(name: 'Bar', price: 30, quantity: 8)
  ] }
  let(:item) { items.stock.sample }

  it 'returns a stock' do expect(items.stock).to eq(stock) end

  describe '#find_item' do
    subject(:find_item) { items.find_item(item.name) }

    context 'when the item exists' do
      it 'returns the item' do
        expect(find_item).to eq item
      end
    end

    context 'when the item does not exist' do
      let(:item) { Item.new(name: 'FooBar', price: 40) }
      it 'returns the item' do
        expect{ find_item }.to raise_error 'Item could not be found'
      end
    end
  end

  describe '#price_of_item' do
    subject(:price_of_item) { items.price_of_item(item.name) }

    it 'returns the price of an item' do
      expect(price_of_item).to eq item.price
    end
  end
end