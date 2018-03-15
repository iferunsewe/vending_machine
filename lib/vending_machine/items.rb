class Items
  attr_reader :stock

  def initialize(stock: [])
    @stock = create_stock(stock)
  end

  def price_of_item(name)
    find_item(name).price
  end

  def find_item(name)
    item = stock.detect{|item| item.name == name }
    raise "Item: #{name} could not be found" if item.nil?
    item
  end

  def has_item?(name)
    find_item(name).quantity > 0
  end
  
  def reduce_item(name)
    item = find_item(name)
    item.quantity -= 1
    item
  end

  private

  def create_stock(items)
    items.map do |item|
      Item.new(name: item[:name], price: item[:price], quantity: item[:quantity])
    end
  end
end
