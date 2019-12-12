class ApplicationController < ActionController::API
  include ::Authentication::ControllerConcern
  prepend_before_action :authenticate_user!
  check_authorization

  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param_error
  rescue_from CanCan::AccessDenied, with: :deny_access

  def not_found
    render status: :not_found, json: ""
  end

  def deny_access
    head :unauthorized
  end

  def missing_param_error(exception)
    render status: :unprocessable_entity, json: { error: exception.message }
  end
end
