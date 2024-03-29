# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

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
    
  before_save :encrypt_password #call back, calls encrypt password method before saving user
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  #class method definition
 class << self
  def authen(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
    #return nil if user.nil?
    #return user if user.has_password?(submitted_password)
  end

  def authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil #terinary operator
  end
end
  
  private
  
     #set encrypted password field, to encrypted version of user pass  
    def encrypt_password
      self.salt = make_salt if new_record?
     self.encrypted_password = encrypt(password)
    end
    
    #ecrypt password by calling secure_hash method with interpolated salt and string argument 
    def encrypt(string)
     secure_hash("#{salt}--#{string}")
    end
    #make salt using time.now.utc method, interpolate with password
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    #create/convert string to secured encrypted string using Digest SHA2
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
      
end
