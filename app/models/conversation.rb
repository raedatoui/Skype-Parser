class Conversation < ActiveRecord::Base
  
  has_many :messages, :foreign_key => "convo_id"
  set_inheritance_column :ruby_type

  # getter for the "type" column
  def conversation_type
   self[:type]
  end

  # setter for the "type" column
  def conversation_type=(s)
   self[:type] = s
  end  
end
