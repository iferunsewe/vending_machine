class Presenter
  def initialize
    puts '---------------------- VENDING MACHINE ----------------------'
    @cli = HighLine.new
    @machine = Machine.new
  end

  def main_menu
    @cli.choose do |menu|
      menu.prompt = 'Welcome to the vending machine. Please pick an option by picking a number.'
      menu.choice('load vending machine') { loading_menu }
      menu.choice('buy an item') { items_menu }
      menu.choice('show items in the vending machine') do
        say_vending_machine_items
        main_menu
      end
      menu.choice('reload vending machine') { reload_menu }
      menu.choice(:quit, 'Exit vending machine') { exit }
    end
  end

  private

  def loading_menu
    @cli.choose do |menu|
      menu.prompt = 'Please choose an option'
      menu.choice(:preload) do
        preload_option
        items_menu
        main_menu
      end
      menu.choice(:load) do
        load_option
        items_menu
        main_menu
      end
      menu.choice('Back to main menu') { main_menu }
    end
  end

  def items_menu
    @cli.choose do |menu|
      menu.prompt = "What do you want to buy? Enter the number for your item e.g. enter 1 for #{@machine.items.stock[0].name}"
      @machine.items.stock.each do |item|
        menu.choice("#{item.name} - #{format_money(item.price)}") do
          make_transaction(item)
          items_menu
        end
      end
      menu.choice('Back to main menu') { main_menu }
    end
  end

  def reload_menu
    @cli.choose do |menu|
      menu.prompt = 'What do you want to reload?'
      menu.choice('reload item') { reload_item_branch }
      menu.choice('reload float') { reload_float_branch }
      menu.choice('Back to main menu') { main_menu }
    end
  end

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
    say 'The machine is empty!'
  end

  def ask_for_float
    generic_money_question_text('Please load some money so I can give change.')
  end

  def ask_for_customer_money
    generic_money_question_text('Show me the money! Please pay for your item.')
  end

  def ask_for_reload
    generic_money_question_text('How much do you want to reload.')
  end

  def generic_money_question_text(custom_text)
    ask(
      custom_text + '
      The vending machine only takes these coins: 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
Please enter the coin and how many you want to insert into the machine.
Default: '
    ){ |q| q.default = '1p: 100, 20p: 50, £1: 30, £2: 15'} # TODO: validate format
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
    if @machine.items_empty?
      say_empty_machine
    else
      say "The vending machine now contains #{
      @machine.items.stock.map do |item|
        "#{item.quantity} of #{item.name} - #{format_money(item.price)}"
      end.join(', ')}"
    end
  end

  def say_vending_machine_item(name_of_item)
    item = @machine.items.find_item(name_of_item)
    say "The vending machine now contains #{item.quantity} of #{item.name}"
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

  def insufficient_funds_branch(transaction, customer_purse)
    say "You still owe #{format_money(transaction.amount_still_required)}"
    money_answer = ask_for_customer_money
    customer_purse + MoneyCollection.new(convert_money_answer_to_hash(money_answer))
    transaction.customer_purse_total = customer_purse.total
  end

  def make_transaction(item)
    money_answer = ask_for_customer_money
    customer_purse = MoneyCollection.new(convert_money_answer_to_hash(money_answer))
    transaction = Transaction.new(item: item, customer_purse_total: customer_purse.total)
    while transaction.insufficient_funds?
      insufficient_funds_branch(transaction, customer_purse)
    end
    successful_transaction(item.name, transaction, customer_purse)
  end

  def successful_transaction(item_name, transaction, customer_purse)
    @machine.buy(name_of_item: item_name, customer_purse: customer_purse)
    puts "You have bought #{item_name} and are provided with #{format_money(transaction.change)} change"
    say_vending_machine_items
    say_float
  end

  def reload_item_branch
    say_vending_machine_items
    item_name = ask "Which item do you want to reload? Just enter the name e.g. #{@machine.items.stock.sample.name}"
    @machine.reload_item(item_name)
    say_vending_machine_item(item_name)
    reload_menu
  end

  def reload_float_branch
    say_float
    amount_received = MoneyCollection.new(convert_money_answer_to_hash(ask_for_reload))
    @machine.reload_float(amount_received)
    say_float
    reload_menu
  end
end

Presenter.new.main_menu
