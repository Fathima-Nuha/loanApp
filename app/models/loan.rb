class Loan < ApplicationRecord
  belongs_to :user
  has_many :repayments, dependent: :destroy

  enum status: { Requested: 0,  Approved: 1,Open: 2,Closed: 3,Rejected: 4 }

end
