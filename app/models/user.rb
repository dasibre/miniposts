class User < ActiveRecord::Base
  attr_accessible :name, :email
  validates :name,  :presence => true,
                    :length   => {:maximum => 10}
  email_regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  validates :email, :presence => true, 
                    :format => { :with => email_regex  },
                    :uniqueness => { :case_sensitive => false}
      
end
