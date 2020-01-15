class StatusController < ::ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_authorization_check only: :index
  skip_authorize_resource only: :index

  def index
    render plain: 'ok', status: 200
  end
end