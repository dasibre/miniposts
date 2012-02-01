class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  validates :name,  :presence => true,
                    :length   => {:maximum => 50}
  email_regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  validates :email, :presence => true, 
                    :format => { :with => email_regex  },
                    :uniqueness => { :case_sensitive => false}
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..20 }
      
end
