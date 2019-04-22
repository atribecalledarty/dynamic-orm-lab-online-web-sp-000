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
  
  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(', ')
    #also delete 'id'
    #=>['name', 'grade'] => 'name, grade'
    #i need 'name, grade'
  end
  
  def values_for_insert
    #I need "'Bob', 9"
    values = self.class.column_names.map do |column_name|
      "'#{send(column_name)}'" unless send(column_name).nil? #control for id value which will be nil
    end
    
  end
end