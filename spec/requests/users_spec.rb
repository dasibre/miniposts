require 'spec_helper'

describe "Users" do
  
  describe "sign up" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
        visit signup_path
        fill_in "Name",         :with => ""
        fill_in "Email",        :with => ""
        fill_in "Password",        :with => ""
        fill_in "confirmation",        :with => ""
        click_button
        response.should render_template('users/new')
        response.should have_selector('div#error_explanation')
      end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Jeremy Lin"
          fill_in "Email",        :with => "jlin@nyk.com"
          fill_in "Password",        :with => "linfever"
          fill_in "confirmation",        :with => "linfever"
          click_button
          response.should render_template('user/show')
          response.should have_selector('div.flash.success')
        end
      end
      
    end
  end
end
