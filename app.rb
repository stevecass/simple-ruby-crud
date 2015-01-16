require_relative 'parser'
require_relative 'person'
require_relative 'view'
require 'colorize'

class App

  def initialize
    @people = {}
    PeoplePersister.load_people.each { |person| @people[person.id] = person }
    View.show_status "Loaded #{@people.length} people"
    until @quit_requested do 
      main_loop
    end
  end

  def save_people
    PeoplePersister.save_people @people.values
    View.show_status "People collection saved. There are #{@people.count} people."
  end

  def main_loop
    input = View.show_menu @people

    case input.upcase
    when 'C'
      prompt_for_person
    when 'R'
      find_people
    when 'U'
      do_update
    when 'D'
      do_deletion
    when 'Q'
      @quit_requested = true
    end

  end

  def do_deletion
    id = View.prompt_for_id 'delete'
    remove_person(id) if View.prompt_for_confirmation
  end

  def remove_person id
    @people.delete(id)
    save_people
  end

  def do_update
    print "Enter id of a person to update: "
    id = gets.chomp.to_i
    p = @people[id]

    if !p
      puts "Sorry couldn't find a person with that id"
    else
      puts "Enter the updated data below. To leave an item unchanged, enter underscore"
      print "Enter first name: (or _ for #{p.first_name}) "
      p.first_name = text_entered if text_entered
      print "Enter last name: (or _ for #{p.last_name}) "
      p.last_name = text_entered if text_entered
      print "Enter email: (or _ for #{p.email}) "
      p.email = text_entered if text_entered
      print "Enter phone:  (or _ for #{p.phone}) "
      p.phone = text_entered if text_entered
      save_people
    end
  end

  def prompt_for_person
    p = Person.new
    print "Enter first name: "
    p.first_name = gets.chomp
    print "Enter last name: "
    p.last_name = gets.chomp
    print "Enter email: "
    p.email = gets.chomp
    print "Enter phone: "
    p.phone = gets.chomp
    p.created_at = Time.now
    max_person = @people.values.max_by { |ele| ele.id }
    p.id = 1 + max_person.id

    @people[p.id] = p
    save_people
  end
  
  def find_by(by, val)
    return [] if val == nil || by == nil
    results = []
    results << @people.values.select do |p| 
      res = p.send(by) 
      res && val.to_s == res.to_s
    end
    results.flatten
  end

  def find_people
    print "What do you want to find by? "
    field = gets.chomp
    print "What should it match? "
    val = gets.chomp
    results = find_by(field, val)
    results.flatten!
    results.each do |person|
      puts person.to_display
    end
    show_status "Found #{results.size} "
    puts "Press enter to continue"
    gets
  end

end

class PeoplePersister
  
  FILE_NAME = 'people.csv'

  def self.load_people
    result = []
    arr = CSVParser.import FILE_NAME
    arr.each {|h| result << Person.new(h) }
    result
  end

  def self.save_people arr
    arr = arr.map { |p| p.to_hash }
    CSVParser.export FILE_NAME, arr
  end
end

app = App.new

