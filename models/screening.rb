require_relative('../db/sql_runner.rb')

class Screening

  attr_accessor :available_tickets, :tickets_sold
  attr_reader :start_time, :film_id, :id

  def initialize(options)
    @id = options['id'].to_i if options['id'].to_i
    @start_time = options['start_time']
    @film_id = options['film_id'].to_i
    @available_tickets = options['available_tickets'].to_i
    @tickets_sold = options['tickets_sold'].to_i
  end

  def save
    sql = "
    INSERT INTO screenings
    (start_time, film_id, available_tickets, tickets_sold)
    VALUES
    ($1, $2, $3, $4)
    RETURNING id"
    values = [@start_time, @film_id, @available_tickets, @tickets_sold]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update
    sql = "
    UPDATE screenings SET
    (start_time, film_id, available_tickets, tickets_sold)
    =
    ($1, $2, $3, $4)
    WHERE
    id = $5;"
    values = [@start_time, @film_id, @available_tickets, @tickets_sold, @id]
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
    return result.map { |screening| Screening.new(screening) }
  end

  def self.delete_all
    sql = "DELETE FROM screenings;"
    SqlRunner.run(sql)
  end

  def self.ticket_sale(id)
    screenings = Screening.all
    for screening in screenings
      if screening.id == id
        screening.available_tickets -= 1
        screening.tickets_sold += 1
        screening.update
      end
    end
  end

  def self.get_available_tickets(id)
    screenings = Screening.all
    for screening in screenings
      if screening.id == id
        return screening.available_tickets
      end
    end
  end

  def self.get_id(film, time)
    sql = "
    SELECT id FROM screenings
    where screenings.film_id = $1 AND screenings.start_time = $2;"
    values = [film, time]
    result = SqlRunner.run(sql, values)[0]['id']
    return result.to_i
  end

  def self.get_screenings_from_film_id(film_id)
    sql = "SELECT * FROM screenings
    WHERE film_id = $1;"
    values = [film_id]
    result = SqlRunner.run(sql, values)
    return result.map { |screening| Screening.new(screening) }
  end

  def self.most_popular_time(film_id)
    screenings = Screening.get_screenings_from_film_id(film_id)
    sorted_screenings = screenings.sort_by {|screening| screening.tickets_sold}
    most_popular_time = sorted_screenings.pop
    return most_popular_time
  end


end
