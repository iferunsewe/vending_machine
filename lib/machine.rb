require_relative 'items'

class Machine
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

  def buy(name_of_item:, customer_purse:)
    @float + customer_purse
    @items.reduce_item(name_of_item)
  end
end
