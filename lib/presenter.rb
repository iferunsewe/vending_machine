class Presenter
  def initialize
    puts '---------------------- VENDING MACHINE ----------------------'
    @cli = HighLine.new
    @machine = Machine.new
  end

  def loading_menu
    @cli.choose do |menu|
      menu.prompt = 'Please choose an option'
      menu.choice(:preload) do
        preload_option
        items_menu
      end
      menu.choice(:load) do
        load_option
        items_menu
      end
      menu.choice(:quit, 'Exit vending machine') { exit }
    end
  end

  def items_menu
    @cli.choose do |menu|
      menu.prompt = "What do you want to buy? Enter the number for your item e.g. enter 1 for #{@machine.items.stock[0].name}"
      @machine.items.stock.each do |item|
        menu.choice("#{item.name} - #{format_money(item.price)}") do
          make_transaction(item)
        end
      end
      menu.choice(:quit, 'Exit vending machine') { exit }
    end
  end

  private

  def load_option
    say_empty_machine
    load = ask_for_float
    @machine.load_float(convert_money_answer_to_hash(load))
    say_float
    items = ask_for_items
    @machine.load_items(convert_items_to_hash(items))
    say_vending_machine_items
  end

  def preload_option
    say 'You have chosen to preload'
    @machine.use_preloaded_vending_machine
    say_float
    say_vending_machine_items
  end

  def say_empty_machine
    say 'Good choice. The machine is empty and people are hungry!'
  end

  def ask_for_float
    ask(
      'Please load some money so I can give change.' + generic_money_question_text
    ){ |q| q.default = '1p: 100, 20p: 50, £1: 30, £2: 15'} # TODO: validate format
  end

  def ask_for_customer_money
    ask(
      'Show me the money! Please pay for your item.' + generic_money_question_text
    ){ |q| q.default = '1p: 100, 20p: 50, £1: 30, £2: 15'} # TODO: validate format
  end

  def generic_money_question_text
    'The vending machine only takes these coins: 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
Please enter the coin and how many you want to insert into the machine.
Default: '
  end

  def say_float
    say "The vending machine is now loaded with #{format_money(@machine.float.total)}. We're in the money"
  end

  def ask_for_items
    ask(
      'Now please load some items! A maximum of 10. Please enter in the format:
name: <name_of_item>, quantity: <quantity>, price: <price>
Default: '
    ){ |q|
      q.default = 'name: Pot noodles, quantity: 10, price: £1.50'
      q.gather = Machine::MAX_ITEMS
    } # TODO: validate format
  end

  def say_vending_machine_items
    # say "The vending machine now contains #{create_items_table(@machine.items.stock)}"
    say "The vending machine now contains #{
    @machine.items.stock.map do |item|
      "#{item.quantity} of #{item.name} - #{format_money(item.price)}"
    end.join(', ')}"
  end

  def convert_items_to_hash(items)
    items.map do |item|
      {
        name: item[/name:(.*?),/, 1].strip,
        quantity:item[/quantity:(.*?),/, 1].strip,
        price: item.split('price: £')[-1]
      }
    end
  end

  def convert_money_answer_to_hash(money)
    money.split(',').map do |f|
      f.strip.split(': ')
    end.to_h
  end

  def format_money(money)
    Money.new(money, 'GBP').format
  end

  def insufficient_funds_branch(transaction, customer_cash)
    say "You still owe #{format_money(transaction.amount_still_required)}"
    money_answer = ask_for_customer_money
    customer_cash + MoneyCollection.new(convert_money_answer_to_hash(money_answer))
    transaction.customer_cash_total = customer_cash.total
  end

  def make_transaction(item)
    money_answer = ask_for_customer_money
    customer_cash = MoneyCollection.new(convert_money_answer_to_hash(money_answer))
    transaction = Transaction.new(item: item, customer_cash_total: customer_cash.total)
    while transaction.insufficient_funds?
      insufficient_funds_branch(transaction, customer_cash)
    end
    successful_transaction(item.name, transaction, customer_cash)
  end

  def successful_transaction(item_name, transaction, customer_cash)
    @machine.buy(name_of_item: item_name, customer_purse: customer_cash)
    puts "You have bought #{item_name} and are provided with #{format_money(transaction.change)} change"
    say_vending_machine_items
    say_float
  end
end

Presenter.new.loading_menu
