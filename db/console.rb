require 'pg'
require 'pry-byebug'
require_relative('../models/ticket.rb')
require_relative('../models/customer.rb')
require_relative('../models/film.rb')

  Film.delete_all
  Customer.delete_all
  Ticket.delete_all

  customer1 = Customer.new({
    'name' => 'Jimothy Johansson',
    'funds' => 100
    })

  customer2 = Customer.new({
    'name' => 'Baggles Brooth',
    'funds' => 60
    })

  customer3 = Customer.new({
    'name' => 'Herbert Clunkerdunk',
    'funds' => 100
    })

  customer4 = Customer.new({
    'name' => 'Grug',
    'funds' => 50
    })

  customer5 = Customer.new({
    'name' => 'Bill Bell',
    'funds' => 100
    })

  customer1.save
  customer2.save
  customer3.save
  customer4.save
  customer5.save

  film1 = Film.new({
    'title' => 'Disney Wars',
    'price' => 20
    })

  film2 = Film.new({
    'title' => 'Germinator',
    'price' => 10
    })

  film3 = Film.new({
    'title' => 'India Jones',
    'price' => 10
    })

  film1.save
  film2.save
  film3.save

  ticket1 = Ticket.new({
    'customer_id' => customer1.id,
    'film_id' => film1.id
    })

  ticket2 = Ticket.new({
    'customer_id' => customer2.id,
    'film_id' => film2.id
    })

  ticket3 = Ticket.new({
    'customer_id' => customer3.id,
    'film_id' => film3.id
    })

  ticket4 = Ticket.new({
    'customer_id' => customer4.id,
    'film_id' => film2.id
    })

  ticket5 = Ticket.new({
    'customer_id' => customer5.id,
    'film_id' => film3.id
    })

  ticket1.save
  ticket2.save
  ticket3.save
  ticket4.save
  ticket5.save


  binding.pry
  nil
