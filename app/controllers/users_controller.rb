class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @users = User.order(email: :asc)
  end
  
  def new
    @user = User.new
  end

  def create
    @password = Devise.friendly_token.first(20)
    admin = 0 # Subscriber
    admin = 1 if params[:user][:role] == "admin"
    email = params[:user][:email]
    name = params[:user][:name]
    @user = User.create!( 
      email: email,
      name: name,
      admin: admin,
      password: @password,
    )
    @verb = "created"
    render :show
  end

  def resetpassword
    @password = Devise.friendly_token.first(20)
    @user = User.find(params[:id])
    @user.update_attributes(password: @password)
    @verb = "updated"
    render :show
  end

  def toggleadmin
    @user = User.find(params[:id])
    @user.admin = (@user.admin + 1) % 2 #toggle between 1 (Admin), and 0 (Normal)
    @user.save
    redirect_to users_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end


end
