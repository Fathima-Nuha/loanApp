class User < ApplicationRecord

	has_secure_password
	enum role: { user: 0,  admin: 1 }
	has_one :wallet, dependent: :destroy
	has_many :loans, dependent: :destroy

	validates :email, presence: true, uniqueness: true,format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
	after_create :create_default_wallet

	private

	def create_default_wallet
    	Wallet.create(user: self)
  	end

end
