# Vending Machine README

Hello!

This program will display all the same functionality as a vending machine. This will include:

    * Buying an item
    * Loading the vending machine with money
    * Loading the vending machine with items
    * Reloading an item
    * Reloading with money
    * Preload with some pre determined money and items 
    * Track what items are in the machine
    * Track how much money is in the machine
    
## Installation

To clone the repository:
    
    git clone
    
Now you'll have to bundle to install all the relevant gems
    
    bundle install
    
## Usage
    
To start the vending machine, please run the following from the root of the project:

    ./lib/vending_machine.rb
    
Then you'll be presented with a few options, pick one by the number it is attached to e.g. 1 for `load vending machine`.

## Options

#### Load vending machine

By default the vending machine will be empty once you start the program. If you choose number 1 on the main menu you will
have two options. Either you can:
    
1. Load the vending machine with items and money. You will be able to load a maximum of 8 items into the vending machine.
You will have to provide a name, price and quanity for an item you want to load. Press enter after each item. 

Expected format: `name: <name_of_item>, quantity: <quantity_of_item>, price: <price_of_item>`

If you want to load money into the vending machine. The machine will only take denominations of 1p, 2p, 5p, 10p, 20p, 
50p, £1, £2. The machine will ask you for the denomination you want to load and the quantity.

2. Preload the vending machine with items and a float that is pre determined. This could be useful if you want to test
other options in the program but do not want to manually load the vending machine.

#### Buy an item

Once the machine has some items, you will be able to buy one from the vending machine. The vending machine will present
you with the items in the vending machine and you will be able to pick one by entering the number it is attached to e.g.

    1. Millions - 70p
    2. Refreshers - 50p
    3. Wham - 30p
    4. Freddos - 20p
    5. Poppets - 55p
    6. Irn Bru - 60p
    7. Chewits - £1.00
    8. Love Hearts - 95p
    9. Back to main menu
    
Enter 3 for `Wham`

You will then be asked to enter some money. Do so by entering the denomination and the quantity e.g.

    if you enter `20p: 2`, you have inserted 2 20p coins
    
After entering money, you will be told how much change you will receive if you have any. The amount of the item you have
bought should decrease and the money in the vending machine should increase.

After buying the machine will ask you if you want to buy another item or return to the main menu.
   
#### Show the items in the vending machine

The machine will tell you the name, price and quantity of each item in the vending machine. If it is empty, the machine
will also tell you it is empty

#### Show the money in the vending machine

The machine will tell you how money the machine has.

### Reload vending machine

The machine will ask you whether you want to:

1. Reload an item. The machine will present you with the items and their quantity in the machine. Choose an item by
entering it's name. Once you choose an item the machine will set the quantity of this item to 10.

2. Reload the float. The machine will ask you to reload money. This can be done by entering the denomination of money
and the quantity.

## Tests

To run all the tests:
    
    bundle exec rspec
