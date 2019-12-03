class Api::V1::UsersController < ::ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  #before_action :set_user, except: [:index, :create]
  load_and_authorize_resource

  def index
    #@users = User.all
    puts current_user.inspect
    render json: @users.to_json(user_json_params)
  end

  def show
    render json: @user.to_json(user_json_params)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user.to_json(user_json_params), status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    head :no_content
  end

  private

  def user_json_params
    current_user&.role == 'admin' ? {} : {only: [:email, :token]}
  end

  def set_user
    @user = current_user&.role == 'admin' ? User.find(params[:id]) : current_user
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
