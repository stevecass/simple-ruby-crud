require_relative 'parser'
require_relative 'person'
require 'colorize'

class App

  def initialize
    @people = {}
    PeoplePersister.load_people.each { |person| @people[person.id] = person }
    puts "Loaded #{@people.length} people"
    until @quit_requested do 
      main_loop
    end
  end

  def save_people
    PeoplePersister.save_people @people.values
    show_status "People collection saved. There are #{@people.count} people."
  end

  def cls
    print "\e[2J"
    print "\e[H"
  end

  def show_status s
    puts s.colorize(:green)
    sleep 1
  end

  def warn s
    puts s.colorize(:orange)
    sleep 1
  end

  def show_error s
    puts s.colorize(:red)
    sleep 1
  end

  def show_menu
    cls
    puts "What do you want to do?"
    puts "C - create a new person"
    puts "R - retrieve a person / some people"
    puts "U - update a record "
    puts "D - delete a person"
    puts "Q - quit"
    puts "We are managing #{@people.count} people."

    input = gets.chomp

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

  def main_loop
    show_menu
  end

  def do_deletion
    print "Enter id of a person to delete: "
    id = gets.chomp.to_i
    print "Are you sure? "
    reply = gets.chomp
    remove_person(id) if reply.upcase == "Y"
  end

  def remove_person id
    @people.delete(id)
    save_people
  end


  def text_entered
    s = gets.chomp
    s == '_' ? nil : s
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
    @people.values.select do |p| 
      res = p.send(by) 
      res && val.to_s == res.to_s
    end
  end

  def find_people
    print "What do you want to find by? "
    field = gets.chomp
    print "What should it match? "
    val = gets.chomp
    results = find_by(field, val)
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

