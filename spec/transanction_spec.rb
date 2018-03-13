require 'spec_helper'

RSpec.describe Transaction do
  subject(:transaction) { described_class.new(item: item, customer_cash_total: customer_cash_total) }
  let(:item) { Item.new(name: 'Foo', price: 40, quantity: 5) }
  let(:customer_cash_total) { 40 }

  describe '#sufficient_funds?' do
    subject(:sufficient_funds?) { transaction.sufficient_funds? }

    context 'when there is more customer cash than the price of the item' do
      let(:customer_cash_total) { 50 }
      it 'returns true' do
        expect(sufficient_funds?).to eq true
      end
    end

    context 'when the customer cash and the price of the item are equal' do
      let(:customer_cash_total) { 40 }
      it 'returns true' do
        expect(sufficient_funds?).to eq true
      end
    end

    context 'when there is less customer cash than the price of the item' do
      let(:customer_cash_total) { 30 }
      it 'returns false' do
        expect(sufficient_funds?).to eq false
      end
    end
  end

  describe '#insufficient_funds?' do
    subject(:insufficient_funds?) { transaction.insufficient_funds? }

    context 'when there is more customer cash than the price of the item' do
      let(:customer_cash_total) { 50 }
      it 'returns false' do
        expect(insufficient_funds?).to eq false
      end
    end

    context 'when the customer cash and the price of the item are equal' do
      let(:customer_cash_total) { 40 }
      it 'returns false' do
        expect(insufficient_funds?).to eq false
      end
    end

    context 'when there is less customer cash than the price of the item' do
      let(:customer_cash_total) { 30 }
      it 'returns true' do
        expect(insufficient_funds?).to eq true
      end
    end
  end
end
