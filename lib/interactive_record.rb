require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name
    self.to_s.downcase.pluralize
  end
  
  def self.column_names
    DB[:conn].results_as_hash = true #returns results as hash
    sql = "PRAGMA table_info('#{table_name}')"
    
    DB[:conn].execute(sql).map do |column_info|
      column_info["name"]
    end
  end
  
  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
  end
  
  #INSERT INTO students (name, grade)
  #VALUES ('Bob', 9)
  def table_name_for_insert
    self.class.table_name
  end
  
  def 
end