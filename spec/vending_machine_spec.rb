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
      expect(vending_machine.items).to eq items
    end
  end
end
