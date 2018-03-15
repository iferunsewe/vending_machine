#!/usr/bin/env ruby

require 'pry'
require_relative 'item'
require_relative 'items'
require_relative 'money_collection'
require_relative 'transaction'
require_relative 'machine'
require 'highline/import'
require 'highline'
require 'money'
require 'terminal-table'
I18n.enforce_available_locales = false
require_relative 'presenter'

Presenter.new.main_menu
