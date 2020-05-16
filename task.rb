# Tasks with title, description and done attributes
class Task
  attr_reader :title, :description
  attr_accessor :done
  def initialize ( attr= {})
    @id = attr[:id]
    @title = attr[:title]
    @description = attr[:description]
    @done = attr[:done] || false
  end
  
  def self.find(id)
    row = DB.execute("SELECT * FROM tasks WHERE id =?",id)[0]
    build_task(row)
  end
  
  def save
    if @id.nil?
      DB.execute(
        "INSERT INTO tasks (title, description, done) VALUES (?, ?,? )",
        @title,
        @description,
        @done ? 1 : 0)
      @id = DB.last_insert_row_id
    else
      DB.execute(
        "UPDATE tasks SET title = ?, description = ?, done = ?  WHERE id = ?", 
        @title, 
        @description, 
        @done ? 1 : 0, 
        @id
      )
    end
  end
  
  def self.all
    raw_tasks = DB.execute("SELECT * FROM tasks")
    raw_tasks.map do |raw_task|
      build_task(raw_task)
    end
  end
  
  def self.build_task(raw_task)
    Task.new(
      id: raw_task["id"], 
      title: raw_task["title"], 
      description: raw_task["description"], 
      done: raw_task["done"]==1 
    )
  end
  
  def delete
    DB.execute("DELETE FROM tasks WHERE id = ?", @id)
  end

end
