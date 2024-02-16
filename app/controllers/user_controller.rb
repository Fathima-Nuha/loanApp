class UserController < ApplicationController

	 before_action :redirect_if_not_logged_in_and_not_user


	def user_dashboard
    	@loan = Loan.new
    	@approved_loans = current_user.loans.where(status: 'Approved')
    	@your_loans = current_user.loans.order(:status)
	end

	def request_loan
		loan_amount = params[:loan][:amount]
		current_user.loans.create(loan_amount:loan_amount,status:0)
		redirect_to user_dashboard_path
	end

	def repay_loan_details
		loan_account_number = params[:loan][:loan_id][6..-1]
		redirect_to loan_repayment_path(id:loan_account_number)
	end

	def loan_repayment
		@loan = Loan.find(params[:id])
		@repayed_sum = @loan.repayments.sum(:amount)
	end

	def repay_amount	
		amount = params[:amount].to_d
		admin = User.find_by(role: "admin")
		loan = Loan.find(params[:loan_id])
		today = Date.today
		loan.repayments.create(payment_date: today,amount: amount)
		current_user.wallet.update(money: current_user.wallet.money - amount)
		admin.wallet.update(money: admin.wallet.money + amount)
		balance_to_pay = loan.amount_to_repay - loan.repayments.sum(:amount)
		if balance_to_pay == 0.0
			loan.update(status: "Closed")
		end
		redirect_to loan_repayment_path(id:loan.id)
	end

	def open_loan

		accepted_loan = Loan.find(params["loan_id"])
		accepted_loan.update(status:"Open" , confirmed_by_user_at:Time.now,amount_to_repay:accepted_loan.loan_amount)
		user_wallet_money = current_user.wallet.money
		user_requested_loan_amount = accepted_loan.loan_amount
		current_user.wallet.update(money:(user_wallet_money+user_requested_loan_amount ))
		admin = User.find_by(role:"admin")
		admin.wallet.update(money:(admin.wallet.money - user_requested_loan_amount))

		#status open
		#created time update .now
		#wallet action in user and admin add and subtract
	end

	def reject_loan
		rejected_loan = Loan.find(params["loan_id"])
		rejected_loan.update(status:"Rejected")

	end

	def view_loan_details
		@loan = Loan.find(params[:loan_id])
		@repayed_sum = @loan.repayments.sum(:amount)
		@repayment_details = @loan.repayments
		render 'view_loan_detail'
	end

	private

  

	def redirect_if_not_logged_in_and_not_user
		if current_user
			unless current_user.role == "user"
      			redirect_back(fallback_location: admin_dashboard_path)
			end
		else
			redirect_to root_path
		end
	end

end


