class Transaction
  def initialize(item:, customer_cash_total:)
    @item = item
    @customer_cash_total = customer_cash_total
    @amount_required = @item.price
  end

  def sufficient_funds?
    @customer_cash_total >= @amount_required
  end

  def insufficient_funds?
    !sufficient_funds?
  end
end
