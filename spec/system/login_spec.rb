require 'rails_helper'
require_relative 'login'


RSpec.describe "Sign up", type: :system do
	include Login
 include Rails.application.routes.url_helpers
	it 'existing user' do 
		user = User.create(name:"fathima",email:"fathimaa@gmail.com",password:"123",password_confirmation:"123",role:"user")
		puts "user",user.to_json
		user.save!
		visit sign_up_path
		fill_in "user_name", with: "Nuha"
		fill_in "user_email", with: "fathimaa@gmail.com"
		fill_in "user_password", with: "passw"
		fill_in "user_password_confirmation", with: "passw"
		click_button "Submit"
		expect(page).to have_content("Error! Email already exists. Please choose a different one.")	

	end
		def login_user(email="fathimanuha0002@gmail.com",password="passw")
			visit root_path
			expect(page).to have_content("Email")
			fill_in "email", with: email
			fill_in "password", with: password
			click_button "Login"
		end

		def admin_login
			visit root_path
			expect(page).to have_content("Email")
			fill_in "email", with: "admin@example.com"
			fill_in "password", with: "password"
			click_button "Login"
		end
	
	  it "Successful admin login" do 

	    user = FactoryBot.create(:user)
		admin
		expect(page).to have_content("Welcome #{user.name}")	
		# click_button "Logout"

	end

	it "Enter user details" do

		visit sign_up_path
		fill_in "user_name", with: "Fathima Nuha"
		fill_in "user_email", with: "fathimanuha0002@gmail.com"
		fill_in "user_password", with: "passw"
		fill_in "user_password_confirmation", with: "passw"
		click_button "Submit"
		expect(page).to have_content("Rs10000")	
		click_button "Logout"

	end

it "Invalid User " do

		login_user("fathimanuha@gmail.com","pass")
		expect(page).to have_content("Error! Invalid email or password.")	

	end
	it "Invalid password" do

		login_user("fathimanuha0002@gmail.com","pass")
		expect(page).to have_content("Error! Invalid email or password.")	

	end

	it "Successfull login" do

		login_user
		user = User.find_by(email:"fathimanuha0002@gmail.com")
		expect(page).to have_content("Welcome #{user.name}")
		click_button "Logout"

	end

	it "Request for loan" do

		login_user

		fill_in "loan_amount", with:"2000"
		click_button "Request"

	end

	it "Check for requested loan in admin" do 

		# user = FactoryBot.create(:userr)
		login_user

		fill_in "loan_amount", with:"5000"
		click_button "Request"


		loan_id = find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/th[1]').text
		puts "loan_id 1",loan_id
		amount =  find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/td[1]').text
	
		click_button "Logout"
		
		admin_login

		loan_id_element = find(:xpath,'/html/body/div[1]/div/table/tbody/tr[1]/th[2]')
		puts "loan_id_element",loan_id_element
	      
	    if has_selector?(:xpath, loan_id_element.path, text: loan_id)
	    	puts "tryeee1"
	    end

		expect(page).to have_xpath('/html/body/div[1]/div/table', wait: 10)
		# sleep(14)

		 within :xpath, '/html/body/div[1]/div/table/tbody/tr[1]' do

	      loan_id = find(:xpath, '/html/body/div[1]/div/table/tbody/tr[1]/th[2]').text
	      expect(page).to have_selector("td", text: amount)
	      expect(page).to have_selector("td", text: "5.0")
	      click_button "Approve"
	    end

	    within :xpath, '/html/body/div[1]/div/table/tbody/tr[1]' do

	      loan_id = find(:xpath, '/html/body/div[1]/div/table/tbody/tr[1]/th[2]').text
	      # expect(page).to have_selector("td", text: amount)
	      # expect(page).to have_selector("td", text: "5.0")
	      click_button "Approve"
	    end

	end

	it 'accept loan from user end' do 

		user = User.find_by(email:"fathimanuha0002@gmail.com")
		admin = User.find_by(email:"admin@example.com")
		login_user
		

		within :xpath, '/html/body/div/div[2]/div/table/tbody/tr[1]' do 

			click_button "Accept"
		end

		visit user_dashboard_path

		expect(user.wallet.money).to eq(10000+2000)
		expect(admin.wallet.money).to eq(1000000-2000)
	
	end

	it 'reject loan from user end' do 

		login_user
		# sleep(15)
		within :xpath, '/html/body/div/div[2]/div/table/tbody/tr' do 

			click_button "Reject"
		end
	end


	it 'repayment loan' do 

		login_user
		# sleep(5)

		#ID of second loan given in previous it block
		loan_id = find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/th').text
		loan_element_id = find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/th')
		
		fill_in "loan_loan_id", with:loan_id
		click_button "Repay"
		fill_in "amount", with:"100"
		click_button "Pay"
		visit user_dashboard_path

		within :xpath, '/html/body/div/div[3]/div/table/tbody/tr[1]' do 

			if has_selector?(:xpath, loan_element_id.path, text: loan_id)
			click_button "View Details"

   		 	end
		end
	end

	it 'try invalid repayment' do 
		login_user
		loan_id = find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[2]/th').text
		fill_in "loan_loan_id", with:loan_id
		click_button "Repay"
		expect(page).to have_content("Error! You loan is not yet open")
	end

	it 'value deducted from user and added to admin' do 

		user = User.find_by(email:"fathimanuha0002@gmail.com")
		admin = User.find_by(email:"admin@example.com")
		expect(user.wallet.money).to eq(10000+2000-100)
		expect(admin.wallet.money).to eq(1000000-2000+100)
		# sleep(15)
	end

	it 'Delete an account' do 

		visit sign_up_path
		fill_in "user_name", with: "Fathima Nuuha"
		fill_in "user_email", with: "fathimanuuha0002@gmail.com"
		fill_in "user_password", with: "passw"
		fill_in "user_password_confirmation", with: "passw"
		click_button "Submit"
		sleep(14)

		user = User.find_by(email:"fathimanuuha0002@gmail.com")
		puts "username",user

		expect(page).to have_content("Welcome #{user.name}")	

		click_button "Delete Account"

		expect(page).to have_content("#{user.name}, your account has been successfully been deleted")	


		sleep(14)
	end

	
	

end

