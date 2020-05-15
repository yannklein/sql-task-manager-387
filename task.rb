# Tasks with title, description and done attributes
class Task
  attr_reader :title, :description, :id
  attr_accessor :done
  def initialize(attributes = {})
    @title = attributes[:title]
    @description = attributes[:description]
    @done = attributes[:done] || false
    @id = attributes[:id]
  end

  def self.find(id)
    results = DB.execute("SELECT * FROM tasks WHERE id = ?", id) # return an array of hashes
    # p results.first
    Task.new(to_hash_with_sym(results.first))
    # return Task instance
  end

  def save
    if @id.nil?
    # Creation
      DB.execute("INSERT INTO tasks (title, description, done) VALUES (?, ?, ?)", @title, @description, (@done ? 1 : 0))
      @id = DB.last_insert_row_id
    else
      # Update
      DB.execute("UPDATE tasks SET title = ?, description = ?, done = ? WHERE id = ?", @title, @description, (@done ? 1 : 0), @id)
    end
  end

  def self.all
    results = DB.execute("SELECT * FROM tasks") # array of hashes
    results.map do |result|
      # result is a hash with string keys
      Task.new(to_hash_with_sym(result))
    end
    # return an array of Task instances
  end

  def delete
    DB.execute("DELETE FROM tasks WHERE id = ?", @id)
  end

  private

  def self.to_hash_with_sym(hash_with_string)
    # hash_with_string.transform_keys!(&:to_sym)
    {
      id: hash_with_string["id"],
      title: hash_with_string["title"],
      description: hash_with_string["description"],
      done: hash_with_string["done"] == 1
    }
  end
end
