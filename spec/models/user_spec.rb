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

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Kofi Ntim", :email => "kintim@gmail.com", :password => "foobar", :password_confirmation => "foobar" }
    @invalid_addresses = %w[Joe.gmail.com kwasi?gmail fred]
    @valid_addresses = %w[jnaadjie@gmail.com fred@example.jp fred_smith@example.org fred-smith@example.co.uk]
  end
  it "should create a new user instance" do
    User.create!(@attr)
  end
  
  it "should have name" do
    user_name = User.new(@attr.merge(:name => ""))
    user_name.should_not be_valid
  end
  
  it "should have an email address" do
    user_email = User.new( :name => "User", :email => "")
    user_email.should_not be_valid
  end
  
  it "should only have 50 character name" do
    user_num_name = "a" * 51
    user_name = User.new( :name => user_num_name, :email => "user@gmail.com")
    user_name.should_not be_valid
  end
  
  it "should reject invalid emails" do
          #addresses = %w[Joe.gmail.com kwasi?gmail fred]
          @invalid_addresses.each do |add|
          user_email = User.new(@attr.merge(:email => add))
          user_email.should_not be_valid
        end
  end
  
   it "should have valid emails" do
           @valid_addresses.each do |add|
           user_email = User.new(@attr.merge(:email => add))
           user_email.should be_valid
         end
   end
  
  it "should reject duplicate emails" do
            User.create!(@attr)
            user_with_duplicate = User.new(@attr)
            user_with_duplicate.should_not be_valid
  end
  
  it "should reject email address identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
    
    describe "passwords" do
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should require a password" do
        @user.should respond_to(:password)
      end
      
      it "should require a password confirmation" do
        @user.should respond_to(:password_confirmation)
      end
    end
    
    describe "password validations" do
      
      it "should reject empty passwords" do
        user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
        user.should_not be_valid
      end
      
      it "should reject short passwords" do
        short = "a" * 5
        hash = User.new(@attr.merge(:password => short, :password_confirmation => short))
        hash.should_not be_valid
      end
      
      it "should reject long passwords" do
        long = "a" * 21
        hash = User.new(@attr.merge(:password => long, :password_confirmation => long))
        hash.should_not be_valid
      end
    end
    
    describe "encrypted password" do
      
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should not be blank" do
        @user.encrypted_password.should_not be_blank
      end
      
      it "should have a salt" do
        @user.should respond_to(:salt)
      end
    end
    
    describe "has_password? method" do
      before(:each) do
        @user= User.create!(@attr)
      end
      it "should exist" do
        @user.should respond_to(:has_password?)
      end
      
      it "should return true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should return false if passwords dont match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
     
      it "should exist" do
        User.should respond_to(:authen)
      end
      
      it "should return nil on email/password mismatch" do
        wrong_user_password = User.authen(@attr[:email], "wrongpass")
        wrong_user_password.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        User.authen("bare@foo.com", @attr[:password]).should be_nil
      end
      
      it "should return user on email/password match" do
        User.authen(@attr[:email], @attr[:password]).should == @user
      end
    end
    
end
