FactoryBot.define do
  factory :user do
    name { 'Admin User'}
    email { 'admin@example.com' }
    password { 'password' }
    role { 1 }

    after(:create) do |user|
      user.wallet.update(money: 1000000)
    end
  end

  factory :userr do 
    name { 'Nuha'}
    email { 'nuha@gmail.com' }
    password { '123' }
    role { 0 }
  end

end