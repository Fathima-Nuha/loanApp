class AdminController < ApplicationController
	
	 before_action :redirect_if_not_logged_in_and_not_admin

	

	def admin_dashboard
		@loans = Loan.all.where(status: "Requested")
		@all_loans = Loan.where(status: ["Open", "Closed"]).order(:status)

	end

	def reject_loan
		rejected_loan = Loan.find(params["loan_id"])
		rejected_loan.update(status:"Rejected")

	end

	def update_loan
		loan_id = params[:id]
		loan = Loan.find(loan_id).update(interest_rate: params[:interest_rate],status:"Approved")
	end

	def view_loan_details
		@loan = Loan.find(params[:loan_id])
		@repayed_sum = @loan.repayments.sum(:amount)
		@repayment_details = @loan.repayments
		render 'view_loan_detail'
	end

	private

  

	def redirect_if_not_logged_in_and_not_admin
		if current_user
			unless current_user.role == "admin"
      			redirect_back(fallback_location: user_dashboard_path)
			end
		else
			redirect_to root_path
		end
	end

end
