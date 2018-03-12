class VendingMachine
  attr_reader :float, :items

  def initialize
    @items = []
    @float = 0
  end

  def load_items(items)
    @items = items
  end
end
