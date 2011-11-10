class Message < ActiveRecord::Base
  
  belongs_to :conversation
   set_inheritance_column :ruby_type

   # getter for the "type" column
   def message_type
    self[:type]
   end

   # setter for the "type" column
   def message_type=(s)
    self[:type] = s
   end


end
