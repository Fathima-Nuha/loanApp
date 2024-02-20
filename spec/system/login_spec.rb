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
		
	
	  it "Successful admin login" do 
	    user = FactoryBot.create(:user)
		visit root_path
		fill_in "email", with:"admin@example.com"
		fill_in "password", with:"password"
		click_button "Login"
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
		click_button "Logout"	


	end

	it "Request for loan" do
		visit root_path
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "passw"
		click_button "Login"
		fill_in "loan_amount", with:"2000"
		click_button "Request"
	end

	it "Check for requested loan in admin" do 
		# user = FactoryBot.create(:userr)
		visit root_path
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "passw"
		click_button "Login"

		fill_in "loan_amount", with:"5000"
		click_button "Request"


		loan_id = find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/th').text
		amount =  find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/td[1]').text
		puts "loan_id",loan_id
		puts "amount",amount
		click_button "Logout"
		# visit root_path

		fill_in "email", with:"admin@example.com"
		fill_in "password", with:"password"
		click_button "Login"
		loan_id_element = find(:xpath,'/html/body/div[1]/div/table/tbody/tr[1]/th[2]')
		puts "loan_id_element",loan_id_element
	      
	    if has_selector?(:xpath, loan_id_element.path, text: loan_id)
	    end

		expect(page).to have_xpath('/html/body/div[1]/div/table', wait: 10)
		sleep(14)

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
		visit root_path
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "passw"
		click_button "Login"
		sleep(15)

		within :xpath, '/html/body/div/div[2]/div/table/tbody/tr[1]' do 
			click_button "Accept"
		end
		visit user_dashboard_path
		expect(user.wallet.money).to eq(10000+2000)
		expect(admin.wallet.money).to eq(1000000-2000)
		# sleep(15)
	end

	it 'reject loan from user end' do 
		visit root_path
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "passw"
		click_button "Login" 
		sleep(15)
		within :xpath, '/html/body/div/div[2]/div/table/tbody/tr' do 
			click_button "Reject"
		end
	end


	it 'repayment loan' do 
		visit root_path
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "passw"
		click_button "Login"
		# sleep(5)
		#ID of second loan given in previous it block
		loan_id = find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/th').text
		loan_element_id = find(:xpath,'/html/body/div/div[3]/div/table/tbody/tr[1]/th')
		puts "loan_id",loan_id
		fill_in "loan_loan_id", with:loan_id
		click_button "Repay"
		fill_in "amount", with:"100"
		click_button "Pay"
		visit user_dashboard_path

		within :xpath, '/html/body/div/div[3]/div/table/tbody/tr[1]' do 
			if has_selector?(:xpath, loan_element_id.path, text: loan_id)
			puts "trueeee2"
			click_button "View Details"

   		 	end
		end
		

	end

	it 'value deducted from user and added to admin' do 
		user = User.find_by(email:"fathimanuha0002@gmail.com")
		admin = User.find_by(email:"admin@example.com")
		expect(user.wallet.money).to eq(10000+2000-100)
		expect(admin.wallet.money).to eq(1000000-2000+100)
		# sleep(15)
	end

	it 'click on view details' do 
	visit root_path
		fill_in "email", with: "fathimanuha0002@gmail.com"
		fill_in "password", with: "passw"
		click_button "Login"	
	end

	
	

end

