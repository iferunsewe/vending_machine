require 'spec_helper'

RSpec.describe VendingMachine do
  subject(:vending_machine) { described_class.new }
  let(:items) { [
    Item.new(name: 'Foo', price: 40, quantity: 5),
    Item.new(name: 'Bar', price: 30, quantity: 8)
  ] }
  let(:money_options){ {
    '5p' => '10',
    '20p' => '3',
    '50p' => '4',
    '£1' => '4',
  } }

  describe '#load_items' do
    subject(:load_items) { vending_machine.load_items(items) }
    it 'sets the items attribute in the vending_machine' do
      load_items
      expect(vending_machine.items.stock).to eq items
    end
  end

  describe '#load_float' do
    subject(:load_float) { vending_machine.load_float(money_options) }
    it 'sets the float attribute in the vending_machine' do
      expect{ load_float }.to change{ vending_machine.float }.from(nil).to(MoneyCollection)
    end
  end

  describe '#buy' do
    subject(:buy) { vending_machine.buy(name_of_item: name_of_item, customer_purse: customer_purse) }
    let(:name_of_item) { items.sample.name }
    let(:denomination) { '20p' }
    let(:quantity) { 3 }
    let(:customer_purse) { MoneyCollection.new({ denomination => quantity}) }

    context 'when the vending machine is loaded' do
      it 'reduces the number of the item in stock by 1' do
        vending_machine.load_items(items)
        vending_machine.load_float(money_options)
        expect{ buy }.to change{ vending_machine.items.find_item(name_of_item).quantity }.by -1
      end

      it 'adds to the total in the float' do
        vending_machine.load_items(items)
        vending_machine.load_float(money_options)
        amount_added = MoneyCollection::DENOMINATIONS[denomination] * quantity.to_i
        expect{ buy }.to change{ vending_machine.float.total }.by amount_added
      end

      it 'increases the coins entered ' do
        vending_machine.load_items(items)
        vending_machine.load_float(money_options)
        amount_added = MoneyCollection::DENOMINATIONS[denomination] * quantity.to_i
        expect{ buy }.to change{ vending_machine.float.twenty_p }.by amount_added
      end
    end
  end
end
