class InterestCalculatorJob < ApplicationJob
  queue_as :default

  def perform

    @loans = Loan.where(status: "Open")
    @loans.each do |loan|
      principal = loan.loan_amount
      rate = (loan.interest_rate)/(100)
      time_difference_in_years = (Time.current - loan.confirmed_by_user_at) / 1.year
      interest_amount = principal * rate * time_difference_in_years
      loan.update(amount_to_repay: principal + interest_amount)
      user = loan.user
      LoanDebitJob.perform_later(user,loan)

    end
  end
end

# Sidekiq::Cron::Job.create(name: 'Hard worker - every 5min', cron: '*/5 * * * *', class: 'InterestCalculatorJob')