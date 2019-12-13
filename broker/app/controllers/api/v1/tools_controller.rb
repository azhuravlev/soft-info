class Api::V1::ToolsController < ::ApplicationController
  load_and_authorize_resource :tool

  def index
    render json: @tools.to_json
  end

  def show
    render json: @tool.to_json
  end

  def create
    @tool = Tool.new(tool_params)
    if @tool.save
      render json: @tool.to_json, status: :created
    else
      render json: @tool.errors, status: :unprocessable_entity
    end
  end

  def update
    if @tool.update(tool_params)
      head :no_content
    else
      render json: @tool.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @tool.destroy

    head :no_content
  end

  private

  def tool_params
    ActionController::Parameters.new(JSON.parse(request.body.read)['tool'] || {}).permit(:name, :repo_url)
  end
end
