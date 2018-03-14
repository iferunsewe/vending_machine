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
      expect{ load_float }.to change{ machine.float }.from(nil).to(MoneyCollection)
    end
  end

  describe '#buy' do
    subject(:buy) { machine.buy(name_of_item: name_of_item, customer_purse: customer_purse) }
    let(:name_of_item) { items.sample[:name] }
    let(:denomination) { '20p' }
    let(:quantity) { 3 }
    let(:customer_purse) { MoneyCollection.new({ denomination => quantity}) }

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

      it 'increases the coins entered ' do
        machine.load_items(items)
        machine.load_float(money_options)
        amount_added = MoneyCollection::DENOMINATIONS[denomination] * quantity.to_i
        expect{ buy }.to change{ machine.float.twenty_p }.by amount_added
      end
    end
  end
end
