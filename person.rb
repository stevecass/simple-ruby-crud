require_relative 'time_helper'

class Person
  attr_accessor :id, :first_name, :last_name, :email, :phone, :created_at

  def initialize(list = {})
    @id = list.fetch(:id,0).to_i
    @first_name = list[:first_name]
    @last_name = list[:last_name]
    @email = list[:email]
    @phone = list[:phone]
    time_string = list[:created_at]
    @created_at =  TimeHelper.time_from_file_format time_string if time_string
  end

  def to_hash
    hash = {}
    instance_variables.each do |var| 
      key = var.to_s.delete("@")
      val = instance_variable_get(var) 
      if key == 'created_at' # handle time to string conversion
        val = TimeHelper.iso_string val
      end
      hash[key] = val
    end
    hash
  end

  def to_display
    "#{first_name} #{last_name} (id #{id})"
  end
end
