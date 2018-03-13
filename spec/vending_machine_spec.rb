require 'spec_helper'

RSpec.describe VendingMachine do
  subject(:vending_machine) { described_class.new }

  describe '#load_items' do
    subject(:load_items) { vending_machine.load_items(items) }
    let(:items) { [
      Item.new(name: 'Foo', price: 40, quantity: 5),
      Item.new(name: 'Bar', price: 30, quantity: 8)
    ] }
    it 'sets the items attribute in the vending_machine' do
      load_items
      expect(vending_machine.items.stock).to eq items
    end
  end

  describe '#load_float' do
    subject(:load_float) { vending_machine.load_float(money_options) }
    let(:money_options){ {
      '5p' => '10',
      '20p' => '3',
      '50p' => '4',
      '£1' => '4',
    } }
    it 'sets the float attribute in the vending_machine' do
      expect{ load_float }.to change{ vending_machine.float }.from(nil).to(MoneyCollection)
    end
  end
end
