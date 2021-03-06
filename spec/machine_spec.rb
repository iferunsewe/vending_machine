require 'spec_helper'

RSpec.describe Machine do
  subject(:machine) { described_class.new }
  let(:items) { [
    {name: 'Foo', price: 40, quantity: 5},
    {name: 'Bar', price: 30, quantity: 8}
  ] }
  let(:money_options){ {
    '5p' => '10',
    '20p' => '3',
    '50p' => '4',
    '£1' => '4',
  } }

  it 'returns a max items of 8' do
    expect(Machine::MAX_ITEMS).to eq 8
  end

  describe '#load_items' do
    subject(:load_items) { machine.load_items(items) }
    let(:item) { items.sample }
    it 'sets the items attribute in the machine' do
      load_items
      expect(machine.items.stock).to all( be_an(Item) )
      expect(machine.items.find_item(item[:name])).to have_attributes(name: item[:name], price: item[:price], quantity: item[:quantity])
    end
  end

  describe '#load_float' do
    subject(:load_float) { machine.load_float(money_options) }
    it 'sets the float attribute in the machine' do
      expect{ load_float }.to change{ machine.float }
    end
  end

  describe '#buy' do
    subject(:buy) { machine.buy(name_of_item: name_of_item, customer_purse: customer_purse, change: customer_change) }
    let(:name_of_item) { items.sample[:name] }
    let(:denomination) { '20p' }
    let(:quantity) { 3 }
    let(:customer_purse) { MoneyCollection.new({ denomination => quantity}) }
    let(:customer_change) { 0 }

    context 'when the vending machine is loaded' do
      it 'reduces the number of the item in stock by 1' do
        machine.load_items(items)
        machine.load_float(money_options)
        expect{ buy }.to change{ machine.items.find_item(name_of_item).quantity }.by -1
      end

      it 'adds to the total in the float' do
        machine.load_items(items)
        machine.load_float(money_options)
        amount_added = MoneyCollection::DENOMINATIONS[denomination] * quantity.to_i
        expect{ buy }.to change{ machine.float.total }.by amount_added
      end

      it 'increases the coins entered' do
        machine.load_items(items)
        machine.load_float(money_options)
        amount_added = MoneyCollection::DENOMINATIONS[denomination] * quantity.to_i
        expect{ buy }.to change{ machine.float.twenty_p }.by amount_added
      end
    end

    context 'when there is change' do
      let(:customer_change) { 20 }

      it 'dedeucts the change from the float total' do
        machine.load_items(items)
        machine.load_float(money_options)
        amount_added = MoneyCollection::DENOMINATIONS[denomination] * quantity.to_i - customer_change
        expect{ buy }.to change{ machine.float.total }.by amount_added
      end
    end
  end

  describe '#use_preloaded_vending_machine' do
    subject(:use_preloaded_vending_machine) { machine.use_preloaded_vending_machine }
    let(:item) { {name: 'Millions', quantity: 10, price: 70} }

    it 'sets the items attribute in the machine' do
      use_preloaded_vending_machine
      expect(machine.items.stock).to all( be_an(Item) )
      expect(machine.items.find_item(item[:name])).to have_attributes(name: item[:name], price: item[:price], quantity: item[:quantity])
    end

    it 'sets the float attribute in the machine' do
      expect{ use_preloaded_vending_machine }.to change{ machine.float }
    end
  end

  describe '#reload_item' do
    subject(:reload_item) { machine.reload_item(name_of_item) }
    let(:name_of_item) { items.sample[:name] }

    context 'when there is less than 10 of the item in the vending machine' do
      it 'reloads the item' do
        machine.load_items(items)
        reload_item
        expect(machine.items.find_item(name_of_item).quantity).to eq Item::MAX_QUANTITY
      end
    end

    context 'when the quantity of the item is exactly 10' do
      it 'returns false' do
        items.detect{|item| item[:name] == name_of_item}[:quantity] = 10
        machine.load_items(items)
        expect(reload_item).to eq false
      end
    end
  end
end
