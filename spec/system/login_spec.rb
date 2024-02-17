require 'rails_helper'


RSpec.describe "Sign up", type: :system do

	# it 'existing user' do 
	# 	user = User.create(name:"fathima",email:"fathimaa@gmail.com",password:"123",password_confirmation:"123",role:"user")
	# 	puts "user",user.to_json
	# 	visit sign_up_path
	# 	fill_in "user_name", with: "Nuha"
	# 	fill_in "user_email", with: "fathimaa@gmail.com"
	# 	fill_in "user_password", with: "passw"
	# 	fill_in "user_password_confirmation", with: "passw"
	# 	click_button "Submit"
	# 	expect(page).to have_content("Error! Email already exists. Please choose a different one.")	

	# end


	it "Enter user details" do
		visit sign_up_path
		fill_in "user_name", with: "Fathima Nuha"
		fill_in "user_email", with: "fathimanuha0002@gmail.com"
		fill_in "user_password", with: "passw"
		fill_in "user_password_confirmation", with: "passw"
		click_button "Submit"
		click_button "Logout"
	end
it "Invalid User " do
		visit root_path
		expect(page).to have_content("Email")
		fill_in "email", with: "fathimanuha@gmail.com"
		fill_in "password", with: "pass"
		click_button "Login"
		expect(page).to have_content("Error! Invalid email or password.")	
	end
	it "Invalid password" do
		visit root_path
		expect(page).to have_content("Email")
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "pass"
		click_button "Login"
		expect(page).to have_content("Error! Invalid email or password.")	
	end

	it "Successfull login" do
		visit root_path
		user = User.find_by(email:"fathimanuha0002@gmail.com")
		expect(page).to have_content("Email")
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "passw"
		click_button "Login"
		expect(page).to have_content("Welcome #{user.name}")	

	end
end

 