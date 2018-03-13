require_relative 'items'

class VendingMachine
  attr_reader :float, :items

  def initialize
    @items = []
    @float = nil
  end

  def load_items(items)
    @items = Items.new(stock: items)
  end

  def load_float(money_options)
    @float = MoneyCollection.new(money_options)
  end
end
