require 'spec_helper'

describe "LayoutLinks" do
    it "should have a Home page at index" do
      get '/'
      response.should have_selector('title', :content => 'Home')
    end
    
    it "should have a contact page at 'contact'" do
      get '/contact'
      response.should have_selector('title', :content => 'Contact')
    end
    
     it "should have an about page at 'about'" do
        get '/about'
        response.should have_selector('title', :content => 'About')
      end
      
       it "should have a help page page at 'contact'" do
          get 'pages/help'
          response.should have_selector('title', :content => 'Help')
        end
end
