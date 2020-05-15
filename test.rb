require 'sqlite3'
DB = SQLite3::Database.new('tasks.db')
DB.results_as_hash = true

# DB reset
DB.execute('DROP TABLE IF EXISTS `tasks`;')
DB.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, done INTEGER DEFAULT (0));')
DB.execute("INSERT INTO tasks (title, description) VALUES ('Complete Livecode', 'Implement CRUD on Task');")

require_relative 'task'

# TODO: CRUD some tasks

# READ (one)
puts '> READ (one)'
task = Task.find(1)
puts "#{task.title}: #{task.description} (done: #{task.done})"

# WRITE
puts '> WRITE'
task = Task.new(title: "Wake up!", description: "RIGHT, NOW!!")
task.save
task = Task.new(title: "Find article for the batch!", description: "Article about managing massive multi query on DB")
task.save
puts "The new id is: #{task.id}"
puts "#{task.title}: #{task.description} (done: #{task.done})"

# UPDATE
puts '> UPDATE'
task = Task.find(2)
task.done = true
task.save
puts "The updated id is: #{task.id}"
puts "#{task.title}: #{task.description} (done: #{task.done})"

# READ (all)
puts '> READ (all)'
tasks = Task.all
tasks.each do |task|
  puts "[#{task.id}] #{task.title}: #{task.description} (done: #{task.done})"
end

# DELETE
puts '> DELETE'
task = Task.find(2)
task.delete
tasks = Task.all
tasks.each do |task|
  puts "[#{task.id}] #{task.title}: #{task.description} (done: #{task.done})"
end
