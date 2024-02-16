require 'rails_helper'

RSpec.describe "First test in login controller",type: :system do
it "Existing User or not" do
	visit root_path
	expect(page).to have_content("Email")
	fill_in "email", with: "fathimanuha0002@gamil.com"
	click_button "Login"
	expect(page).to have_content("Error! Invalid email or password.")	
end
end