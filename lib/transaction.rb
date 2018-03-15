class Transaction
  attr_reader :amount_still_required, :change
  attr_accessor :customer_purse_total

  def initialize(item:, customer_purse_total:)
    @item = item
    @customer_purse_total = customer_purse_total
    @amount_required = @item.price
    @amount_still_required = amount_still_required
    @change = change
  end

  def sufficient_funds?
    customer_purse_total >= @amount_required
  end

  def insufficient_funds?
    !sufficient_funds?
  end

  def amount_still_required
    return 0 if sufficient_funds?
    @amount_required - customer_purse_total
  end

  def change
    return 0 if customer_purse_total == @amount_required || insufficient_funds?
    customer_purse_total - @amount_required
  end
end
