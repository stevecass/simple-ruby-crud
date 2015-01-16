require 'colorize'

class View
  class << self
  
    def text_entered
      s = gets.chomp
      s == '_' ? nil : s
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

    def prompt_for_id operation
      print "Enter an id to #{operation}: "
      id = gets.chomp.to_i
    end

    def prompt_for_confirmation msg="Are you sure? (Y/N)"
      print msg
      reply = gets.chomp
      reply[0].upcase == "Y"
    end

    def show_menu people
      cls
      puts "What do you want to do?"
      puts "C - create a new person"
      puts "R - retrieve a person / some people"
      puts "U - update a record "
      puts "D - delete a person"
      puts "Q - quit"
      puts "We are managing #{people.count} people."

      gets.chomp
    end
  end

end