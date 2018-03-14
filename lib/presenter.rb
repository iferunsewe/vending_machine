class Presenter
  def initialize
    puts '---------------------- VENDING MACHINE ----------------------'
    @cli = HighLine.new
    @machine = Machine.new
    @table = Terminal::Table.new
  end

  def loading_menu
    @cli.choose do |menu|
      menu.prompt = 'Please choose an option'
      menu.choice(:preload) { say 'You have chosesn to preload' }
      menu.choice(:load) do
        load_option
      end
    end
  end

  def items_menu
    @cli.choose do |menu|

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

  def say_empty_machine
    say 'Good choice. The machine is empty and people are hungry!'
  end

  def ask_for_float
    ask(
      'Please load some money so I can give change.
The vending machine only takes these coins: 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
Please enter the coin and how many you want to insert into the machine.
Default: '
    ){ |q| q.default = '1p: 100, 20p: 50, £1: 30, £2: 15'} # TODO: validate format
  end

  def say_float
    say "The vending machine is now loaded with #{format_money(@machine.float.total)}. I'm feeling rich!"
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
      "#{item.quantity} of #{item.name} - £#{item.price}"
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

  def create_items_table(items)
    @table.headings = ['name', 'price', 'quantity']
    @table.rows = items
  end
end

Presenter.new.loading_menu
