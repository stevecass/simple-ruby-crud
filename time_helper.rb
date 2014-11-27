require 'time'

module TimeHelper
  def self.time_from_file_format str
   # e.g. 2012-05-10T03:53:40-07:00 (iso 8601 format)
   Time.parse(str)
  end

  def self.time_string_for_file date
    date.utc.iso8601
  end

end