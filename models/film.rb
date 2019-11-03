require_relative('../db/sql_runner.rb')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save
    sql = "
    INSERT INTO films
    (title, price)
    VALUES
    ($1, $2)
    RETURNING id;"
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update
    sql = "
    UPDATE films SET
    (title, price)
    =
    ($1, $2)
    WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "
    DELETE FROM films
    where id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def show_customers()
    sql = "
    SELECT DISTINCT customers.* FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE tickets.film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    customers = result.map {|customer| Customer.new(customer)}
    return customers
  end

  def customer_count
    return show_customers.count
  end

  def ticket_count
    sql = "
    SELECT * from tickets
    where film_id = $1
    "
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.count
  end

  def self.get_id(film_title)
    sql = "
    SELECT id FROM films
    where films.title = $1;"
    values = [film_title]
    result = SqlRunner.run(sql, values)[0]['id']
    return result.to_i
  end

  def self.all
    sql = "SELECT * FROM films;"
    result = SqlRunner.run(sql)
    return result.map { |film| Film.new(film) }
  end

  def self.delete_all
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

end
