require_relative('../db/sql_runner.rb')

class Screening

  attr_reader :start_time, :film_id, :id

  def initialize(options)
    @id = options['id'].to_i if options['id'].to_i
    @start_time = options['start_time']
    @film_id = options['film_id'].to_i
  end

  def save
    sql = "
    INSERT INTO screenings
    (start_time, film_id)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@start_time, @film_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update
    sql = "
    UPDATE screenings SET
    (start_time, film_id)
    =
    ($1, $2)
    WHERE
    id = $3;"
    values = [@start_time, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "
    DELETE FROM screenings
    where id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  def self.all
    sql = "SELECT * FROM screenings;"
    result = SqlRunner.run(sql)
    return result.map { |ticket| Ticket.new(ticket) }
  end

  def self.delete_all
    sql = "DELETE FROM screenings;"
    SqlRunner.run(sql)
  end

end
