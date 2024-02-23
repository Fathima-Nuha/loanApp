class LoginController < ApplicationController

   before_action :redirect_if_logged_in, except: [:destroy, :delete_account] 

   def sign_in
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      if @user.role=="admin"
        redirect_to "/admin/admin_dashboard", notice: 'Logged in successfully.'
      else
        redirect_to "/user/user_dashboard", notice: 'Logged in successfully.'
      end

    else
      flash[:error] = 'Invalid email or password.'
      redirect_to root_path
    end
  end

   def sign_up
    @user = User.new
  end



  def register

    if User.exists?(email: user_params[:email])
      p "User exists",user_params[:email]
      flash[:error] = "Email already exists. Please choose a different one."
      # redirect_to "/sign_up"
      redirect_to sign_up_path
    else
      @user = User.create(user_params.merge(role: 'user'))
      p "creating new user"
        if @user.save
         session[:user_id] = @user.id
          redirect_to user_dashboard_path
        else
          flash[:error] = @user.errors.full_messages.last
        end
    end
  end

  def delete_account
    @user = User.find(session[:user_id])
    @user.destroy
    flash[:success] = "#{@user.name}, your account has been successfully been deleted"
    session[:user_id] = nil
    redirect_to root_path
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:name,:email, :password, :password_confirmation)
  end

   private

  def redirect_if_logged_in
    if current_user
      if current_user.role=="admin"
        redirect_to admin_dashboard_path
      else
        redirect_to user_dashboard_path
      end
    end
  end
 

 
end
