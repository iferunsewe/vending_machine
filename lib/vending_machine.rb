#!/usr/bin/env ruby

require 'pry'
require 'highline/import'
require 'highline'
require 'money'
I18n.enforce_available_locales = false
require_relative 'vending_machine/item'
require_relative 'vending_machine/items'
require_relative 'vending_machine/money_collection'
require_relative 'vending_machine/transaction'
require_relative 'vending_machine/machine'
require_relative 'vending_machine/presenter'

Presenter.new.main_menu
