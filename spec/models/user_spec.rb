require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Kofi Ntim", :email => "kintim@gmail.com", :password => "foobar", :password_confirmation => "foobar"}
    @invalid_addresses = %w[Joe.gmail.com kwasi?gmail fred]
    @valid_addresses = %w[jnaadjie@gmail.com fred@example.jp fred-smith@example.org]
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
           #addresses = %w[Joe.gmail.com kwasi?gmail fred]
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
        @user = User.new(@attr)
      end
      it "should have password attribute" do
        @user.should respond_to(:password)
      end
      
      it "should have a password confirmation attribute" do
        @user.should respond_to(:password_confirmation)
      end
    end
    
    describe "password validations" do
      
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
      end
      
      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
      end
      
      it "should have a minimum length" do
        short = "a" * 5
        User.new(@attr.merge(:password => short, :password_confirmation => short)).
        should_not be_valid
      end
      
      it "should reject long passwords" do
        long = "a" * 21
        User.new(@attr.merge(:password => long, :password_confirmation => long)).
        should_not be_valid
      end
    end
    
    describe "password encryption" do
      
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should have an encrypted password" do
        @user.should respond_to(:encrypted_password)
      end
    end
end
