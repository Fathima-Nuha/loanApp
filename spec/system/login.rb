# spec/support/login_helpers.rb
module Login
  puts "inside helper login module,,,"
  
  include Rails.application.routes.url_helpers
   # include Capybara::DSL

    def user(email = "fathimanuha0002@gmail.com", password = "passw")
      visit root_path
      expect(page).to have_content("Email")
      fill_in "email", with: email
      fill_in "password", with: password
      click_button "Login"
    end

    def admin
      visit root_path
      expect(page).to have_content("Email")
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "password"
      click_button "Login"
    end
end

