class Dog
  attr_accessor @name, @breed, @id
  def initialize(name:, breed:, id: = nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql =
      "CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      breed TEXT,
      name TEXT;
      )"
    
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs;"

    DB[:conn].execute(sql)
  end

  def save
    sql =
    "INSER INTO dogs (name, breed)
    VALUES (?,?);
    "

    DB[:conn].execute(sql, self.name, self.breed)
  end

  def self.create(name:, breed:)
    dog = Dog.new(id: row[0],name: name, breed: breed)
    dog.save
  end

  def self.new_from_db(row)
    Self.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.all
    sql ="SELECT * FROM dogs;"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql =
    "SELECT * FROM dogs
    WHERE name = ?
    LIMIT 1;
    "
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.find(id)
    sql =
    "SELECT * FROM dogs
    WHERE dogs.id = ?
    LIMIT 1;
    "
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end
end
