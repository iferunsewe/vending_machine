class Items
  attr_reader :stock

  def initialize(stock:)
    @stock = stock
  end

  def find_item(name_of_item)
    item = stock.detect{|item| item.name == name_of_item }
    raise 'Item could not be found' if item.nil?
    item
  end
end