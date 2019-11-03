require_relative('../db/sql_runner.rb')

class Ticket

  attr_reader :customer_id, :film_id, :id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save
    sql = "
    INSERT INTO tickets
    (customer_id, film_id, screening_id)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@customer_id, @film_id, @screening_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update
    sql = "
    UPDATE tickets SET
    (customer_id, film_id, screening_id)
    =
    ($1, $2, $3)
    WHERE
    id = $4;"
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "
    DELETE FROM tickets
    where id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def get_price
    sql = "
    SELECT films.price FROM films
    INNER JOIN tickets
    on films.id = tickets.film_id
    WHERE tickets.id = $1"
    values = [@id]
    price = SqlRunner.run(sql, values)[0]['price']
    return price.to_i
  end

  def self.all
    sql = "SELECT * FROM tickets;"
    result = SqlRunner.run(sql)
    return result.map { |ticket| Ticket.new(ticket) }
  end

  def self.delete_all
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

end
