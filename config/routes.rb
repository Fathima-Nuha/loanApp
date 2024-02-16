Rails.application.routes.draw do
  root 'login#sign_in'
  post 'login/login', as:'login'
  get 'login/sign_up',as:'sign_up'
  post 'login/register',as:"register"
  delete 'login/delete_account/:id',to:'login#delete_account',as:'delete_account'
  delete 'login/destroy',to:'login#destroy',as:'logout'

  get 'user/user_dashboard', as:'user_dashboard'
  post 'user/request_loan',as:'request_loan'
  post 'user/repay_loan_details',as:'repay_loan_details'
  get 'user/loan_repayment/:id',to:'user#loan_repayment',as:'loan_repayment'
  post 'user/repay_amount',as:'repay_amount'
  get 'user/open_loan', as:'open_loan'
  get 'user/reject_loan', as:'reject_loan'
  get 'user/view_loan_details',as:'view_details'

  

  get 'admin/admin_dashboard', as:'admin_dashboard'
  patch 'admin/admin/update_loan/:id', to: 'admin#update_loan', as: 'update_loan'
  get 'admin/reject_loan', as:'admin_reject_loan'
  get 'admin/view_loan_details',as:'admin_view_details'


  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
