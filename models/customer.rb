require 'pg'
require_relative('../db/sql_runner.rb')

class Customer

  attr_reader :name, :funds, :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = "
    INSERT INTO customers
    (name, funds)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]
  end

  def update()
  end

  def delete()
  end

  def self.all()
  end

  def self.delete_all()
  end


end
