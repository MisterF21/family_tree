require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts 'Press c to add a child.'
    puts "Press d to see who a child's parents are."
    puts "Press g to see grand parents of a child."
    puts "Press t to view siblings."
    puts "Press e to exit."
    choice = gets.chomp
    system "clear"

    case choice
    when 'a'
      add_person
    when 'l'
      list
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'c'
      add_child
    when 'd'
      show_parents
    when 'g'
      show_grandparents
    when 't'
      show_siblings
    when 'e'
      exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  Person.create(:name => name)
  puts name + " was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def add_child
  list
  puts 'What is the name of the child?'
  name = gets.chomp
  puts "What is the gender of " + name + "? 'M' for MALE, 'F' for FEMALE."
  gender = gets.chomp.upcase
  puts name + " was added to the family tree.\n\n"
  puts "What is the id number of the first parent?"
  parent1 = Person.find(gets.chomp)
  puts "What is the id number of the second parent?"
  parent2 = Person.find(gets.chomp)
  puts "This childs parents are " + parent1.name + " and " + parent2.name = "."
  child = Person.create(:name => name, :gender => gender, :parent_id1 => parent1.id, :parent_id2 => parent2.id)
  system 'clear'
  puts child.name + "has been created as child."
end

def show_parents
  list
  puts "Please enter the name of a child to view that child's parents."
  child = Person.all.where({:name => gets.chomp}).first
  parents = child.get_parents
  grand_parents = []
  parents.each do |parent|
    puts parent.name
    grand_parents << parent.get_parents
  end
  grand_parents = grand_parents.flatten
  grand_parents.each do |gp|
    puts "#{gp.name}\n"
  end
  puts "\n"
end

def show_grandparents
 list
  puts "Please enter the name of a child to view that child's grand parents."
  child_name = gets.chomp
  child = Person.all.where({:name => child_name}).first
  grand_parents = []
  parents = child.get_parents
  parents.each do |parent|
    grand_parents << parent.get_parents
  end
    grand_parents.each do |gp|
    puts "#{gp[0].name} and #{gp[1].name}"
  end
end

def show_grandchildren
end

def show_siblings
  puts "Please enter the name of a person to view their siblings."
  person_name = gets.chomp
  person = Person.all.where({:name => person_name}).first
  person.each do |person|
    sibling = Person.all.where({:parent_id1 => person.parent_id1})
  end
  puts "#{person} and #{sibling} are siblings."
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
end

menu
