require 'CSV'
module CSVParser
 
  def self.import file #imports csv file; returns array of hashes, one hash per row
    result = CSV.read(file, headers: true, header_converters: :symbol).map(&:to_hash)
    result
  end
 
  def self.export filename, data #IN: file to write and data; OUT: csv file
    CSV.open(filename, 'wb') do |csv|
      csv << data.first.keys
      data.each {|row| csv << row.values}
    end
  end
 
end