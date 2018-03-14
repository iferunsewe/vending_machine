require_relative 'items'

class Machine
  attr_reader :float, :items

  MAX_ITEMS = 8

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

  def use_preloaded_vending_machine
    load_items(DEFAULT_ITEMS)
    load_float(DEFAULT_FLOAT)
  end

  def reload_item(name_of_item)
    item = @items.find_item(name_of_item)
    raise "There is already enough of #{name_of_item} in the vending machine" if item.quantity == Item::MAX_QUANTITY
    item.quantity = Item::MAX_QUANTITY
  end

  private

  DEFAULT_ITEMS =
    [
      {name: 'Millions', quantity: 10, price: 70},
      {name: 'Refreshers', quantity: 10, price: 50},
      {name: 'Wham', quantity: 6, price: 30},
      {name: 'Freddos', quantity: 10, price: 20},
      {name: 'Poppets', quantity: 10, price: 55},
      {name: 'Irn Bru', quantity: 7, price: 60},
      {name: 'Chewits', quantity: 10, price: 100},
      {name: 'Love Hearts', quantity: 10, price: 95},
      {name: 'Caramac', quantity: 2, price: 85},
      {name: 'Polos', quantity: 10, price: 75},
    ]

  DEFAULT_FLOAT = {
    '1p'=> 100,
    '2p' => 500,
    '5p' => 100,
    '10p' => 100,
    '20p' => 50,
    '50p' => 8,
    '£1' => 30,
    '£2' => 15
  }
end
