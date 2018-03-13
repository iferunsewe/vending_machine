require 'spec_helper'

RSpec.describe MoneyCollection do
  subject(:money_collection) { described_class.new(money_options) }
  let(:money_options){ {
    '5p' => '10',
    '20p' => '3',
    '50p' => '4',
    '£1' => '4',
  } }
  let(:denominations_translator) {  MoneyCollection::DENOMINATIONS  }

  context 'when the denomination exists' do
    it 'returns a correct total' do
      expect(money_collection.total).to eq 710
    end

    it 'returns denominations with the correct amount' do
      coin = '50p'
      expect(money_collection.fifty_p).to eq money_options[coin].to_i * denominations_translator[coin]
    end
  end
end
