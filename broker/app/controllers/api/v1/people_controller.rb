class Api::V1::PeopleController < ::ApplicationController
  load_and_authorize_resource :person

  def index
    if stale?(@people)
      people_json = Rails.cache.fetch([:people, @people.cache_version], exptires_in: 1.hour) do
        @people.to_json
      end
      render json: people_json
    end
  end

  def show
    if stale?(@person)
      person_json = Rails.cache.fetch([:person, @person.cache_version], exptires_in: 1.hour) do
        @person.to_json
      end
      render json: person_json
    end
  end

  def create
    @person = person.new(person_params)
    if @person.save
      render json: @person.to_json, status: :created
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def update
    if @person.update(person_params)
      head :no_content
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy

    head :no_content
  end

  private

  def person_params
    ActionController::Parameters.new(JSON.parse(request.body.read)['person'] || {}).permit(:name, :link, :info)
  end
end
