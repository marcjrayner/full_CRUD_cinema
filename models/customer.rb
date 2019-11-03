require_relative('../db/sql_runner.rb')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save
    sql = "
    INSERT INTO customers
    (name, funds)
    VALUES
    ($1, $2)
    RETURNING id;"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update
    sql = "
    UPDATE customers SET
    (name, funds)
    =
    ($1, $2)
    WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "
    DELETE FROM customers
    where id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def show_films()
    sql = "
    SELECT films.* FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    films = result.map {|film| Film.new(film)}
    return films
  end

  def buy_ticket(film_title)
    ticket1 = Ticket.new({
      'customer_id' => @id,
      'film_id' => Film.get_id(film_title)
      })
    ticket1.save
    price = ticket1.get_price
      if @funds >= price
        @funds -= price
      else
        ticket1.delete
      end
      self.update
  end

  def count_tickets()
    sql = "
    SELECT * FROM tickets
    where tickets.customer_id = $1"
    values = [@id]
    ticket_count = SqlRunner.run(sql, values).count
    return ticket_count
  end

  def self.all
    sql = "SELECT * FROM customers;"
    result = SqlRunner.run(sql)
    return result.map { |customer| Customer.new(customer) }
  end

  def self.delete_all
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

end
