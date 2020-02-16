require 'swagger_helper'

RSpec.describe 'People', type: :request, capture_examples: true do
  let!(:people) { create_list(:person, 3) }
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, role: 'admin') }

  path '/people' do
    parameter 'X-AUTH-TOKEN', in: :header, type: :string, description: "AUTH token"

    get(summary: 'Get people') do
      produces 'application/json'
      tags :people

      response(200, description: 'Return all the available people for authorized user') do
        let(:'X-AUTH-TOKEN') { user.token }

        it 'Return 3 people' do
          body = JSON(response.body)
          expect(body.count).to eq(3)
        end
      end

      response(401, description: 'Deny access for unknown token') do
        let(:'X-AUTH-TOKEN') { "unknown" }
      end
    end

    post(summary: 'Create person') do
      produces 'application/json'
      consumes 'application/json'
      tags :people
      parameter :person,
                in: :body,
                required: true,
                schema: {
                    '$ref' => '#/definitions/person'
                }

      let(:person) { { person: { name: 'person', repo_url: 'repo' } } }

      response(201, description: 'Creates person') do
        let(:'X-AUTH-TOKEN') { admin.token }
      end

      response(422, description: 'Return error for wrong parametrs') do
        let(:'X-AUTH-TOKEN') { admin.token }
        let(:person) { { person: { name: 'person' } } }

        it 'Returns error' do
          body = JSON(response.body)
          expect(body['link']).to eq(["can't be blank"])
        end
      end

      response(401, description: 'Deny access for unknown token') do
        let(:'X-AUTH-TOKEN') { "unknown" }
      end
    end
  end

  path '/people/{id}' do
    parameter :id, in: :path, type: :integer, required: true, description: 'person ID'
    parameter 'X-AUTH-TOKEN', in: :header, type: :string, description: "AUTH token"

    get(summary: 'Get person') do
      produces 'application/json'
      tags :people

      response(200, description: 'Return requested person') do
        let(:'X-AUTH-TOKEN') { user.token }
        let(:id) { Person.last.id }

        it 'Return person' do
          body = JSON(response.body)
          expect(body['name']).to eq(Person.last.name)
        end
      end

      response(404, description: 'Return unfound') do
        let(:'X-AUTH-TOKEN') { user.token }
        let(:id) { "any_id" }
      end

      response(401, description: 'Deny access') do
        let(:'X-AUTH-TOKEN') { 'unknown' }
        let(:id) { Person.last.id }
      end
    end

    put(summary: 'Update person') do
      produces 'application/json'
      tags :people
      parameter :person,
                in: :body,
                required: true,
                schema: {
                    '$ref' => '#/definitions/person'
                }
      let(:id) { "any_id" }
      let(:person) { { person: { name: 'person', repo_url: 'repo' } } }

      response(204, description: 'Updates requested person by admin') do
        let(:'X-AUTH-TOKEN') { admin.token }
        let(:id) { Person.last.id }
      end

      response(404, description: 'Return unfound') do
        let(:'X-AUTH-TOKEN') { admin.token }
        let(:id) { "any_id" }
      end

      response(401, description: 'Deny access') do
        let(:'X-AUTH-TOKEN') { 'unknown' }
        let(:id) { Person.last.id }
      end
    end

    delete(summary: 'Destroy person') do
      produces 'application/json'
      tags :people
      let(:id) { Person.last.id }

      response(204, description: 'Destroy person if admin request') do
        let(:'X-AUTH-TOKEN') { admin.token }

        it 'person not exists' do
          expect(Person.find_by(id: id)).to be_nil
        end
      end

      response(404, description: 'Return unfound') do
        let(:'X-AUTH-TOKEN') { admin.token }

        let(:id) { "any_id" }
      end

      response(401, description: 'Deny access for user') do
        let(:'X-AUTH-TOKEN') { user.token }
      end
    end
  end
end
