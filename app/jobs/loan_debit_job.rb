class LoanDebitJob < ApplicationJob
  queue_as :default

  def perform(user,loan)
    admin = User.find_by(role:"admin")
    user_wallent_balance = user.wallet.money
    if user_wallent_balance <= loan.amount_to_repay
      user.wallet.update(money: user.wallet.money - user_wallent_balance)
      admin.wallet.update(money: admin.wallet.money + user_wallent_balance)
      loan.update(status:"Closed")
    end
  end
end
