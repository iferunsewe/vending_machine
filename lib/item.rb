class Item
  attr_accessor :name, :price, :quantity
  MAX_QUANTITY = 10

  def initialize(name:, price:, quantity: 1)
    @name = name
    @price = price
    @quantity = quantity
  end
end
