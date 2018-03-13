class MoneyCollection
  DENOMINATIONS = {
    '1p' => 1,
    '2p' => 2,
    '5p' => 5,
    '10p' => 10,
    '20p' => 20,
    '50p' => 50,
    '£1' => 100,
    '£2' => 200
  }

  attr_reader :total, :one_p, :two_p, :five_p, :ten_p, :twenty_p, :fifty_p, :one_pound, :two_pound

  def initialize(options)
    @options = options
    @one_p = fetch_value('1p')
    @two_p = fetch_value('2p')
    @five_p = fetch_value('5p')
    @ten_p = fetch_value('10p')
    @twenty_p = fetch_value('20p')
    @fifty_p = fetch_value('50p')
    @one_pound = fetch_value('£1')
    @two_pound = fetch_value('£2')
    @total = calculate_total
  end

  def - money_collection
    money_attrs.each do |ivar|
      new_value = instance_variable_get(ivar) - money_collection.instance_variable_get(ivar)
      instance_variable_set(ivar, new_value)
    end
    self
  end

  def + money_collection
    money_attrs.each do |ivar|
      new_value = instance_variable_get(ivar) + money_collection.instance_variable_get(ivar)
      instance_variable_set(ivar, new_value)
    end
    self
  end

  private

  def fetch_value(denomination)
    @options.fetch(denomination, 0).to_i * DENOMINATIONS[denomination]
  end

  def calculate_total
    money_attr_values.reduce(:+)
  end

  def money_attrs
    instance_variables.reject{|var| var == :@options}
  end

  def money_attr_values
    money_attrs.map{|var| instance_variable_get var}
  end
end
