require 'pg'
require 'pry-byebug'
require_relative('../models/customer.rb')
require_relative('../models/film.rb')
require_relative('../models/ticket.rb')

  customer1 = Customer.new({
    'name' => 'Jimothy Johansson',
    'funds' => 100
    })

  film1 = Film.new({
    'title' => 'Gladiator',
    'price' => 10
    })

  binding.pry
  nil
