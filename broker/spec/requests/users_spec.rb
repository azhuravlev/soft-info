require 'swagger_helper'

RSpec.describe 'Users', type: :request, capture_examples: true do
  let!(:admin) { create(:user, role: 'admin') }
  let!(:users) { create_list(:user, 3) }
  let!(:non_admin_user) { users.last }

  path '/users' do
    get(summary: 'Get users') do
      parameter 'X-AUTH-TOKEN', in: :header, type: :string, description: "AUTH token"
      produces 'application/json'
      tags :users

      response(200, description: 'Return all the available users for admin') do
        let(:'X-AUTH-TOKEN') { admin.token }

        it 'Return 3 users' do

          body = JSON(response.body)
          expect(body.count).to eq(4)
        end
      end

      response(200, description: 'Return user') do
        let(:'X-AUTH-TOKEN') { non_admin_user.token }

        it 'Return asked user' do
          body = JSON(response.body)
          expect(body.count).to eq(1)
          expect(body.first['email']).to eq(non_admin_user.email)
        end
      end

      response(401, description: 'Deny access for unknown token') do
        let(:'X-AUTH-TOKEN') { "unknown" }
      end
    end

    post(summary: 'Create user') do
      produces 'application/json'
      consumes 'application/json'
      tags :users
      parameter :user,
                in: :body,
                required: true,
                schema: {
                    '$ref' => '#/definitions/user'
                }

      response(201, description: 'Creates user with given email') do
        let(:user) { { user: { email: 'test@test.com' } } }
      end

      response(422, description: 'Return error if email empty') do
        let(:user) { { user: { email: '' } } }

        it 'Returns error' do
          body = JSON(response.body)
          expect(body['email']).to eq(["can't be blank", "is invalid"])
        end
      end
    end
  end

  path '/users/{id}' do
    parameter :id, in: :path, type: :integer, required: true, description: 'User ID for admin requests'
    parameter 'X-AUTH-TOKEN', in: :header, type: :string, description: "AUTH token"

    get(summary: 'Get user') do
      produces 'application/json'
      tags :users
      let(:id) { "any_id" }

      context "When requested by admin" do
        let(:'X-AUTH-TOKEN') { admin.token }

        response(200, description: 'Return requested user') do
          let(:id) { non_admin_user.id }

          it 'Return user' do
            body = JSON(response.body)
            expect(body['email']).to eq(non_admin_user.email)
          end
        end

        response(404, description: 'Return unfound') do
          let(:id) { "any_id" }
        end
      end

      response(200, description: 'Return user with which token requested') do
        let(:'X-AUTH-TOKEN') { non_admin_user.token }

        it 'Return user' do
          body = JSON(response.body)
          expect(body['email']).to eq(non_admin_user.email)
        end
      end

      response(401, description: 'Deny access') do
        let(:'X-AUTH-TOKEN') { 'unknown' }
      end
    end

    put(summary: 'Update user') do
      produces 'application/json'
      tags :users
      parameter :user,
                in: :body,
                required: true,
                schema: {
                    '$ref' => '#/definitions/user'
                }
      let(:id) { "any_id" }
      let(:user) { { user: { role: 'admin' } } }

      context "When requested by admin" do
        let(:'X-AUTH-TOKEN') { admin.token }

        response(204, description: 'Updates requested user') do
          let(:id) { non_admin_user.id }
        end

        response(404, description: 'Return unfound') do
          let(:id) { "any_id" }
        end
      end

      response(401, description: 'Deny for self-update by non-admin user') do
        let(:'X-AUTH-TOKEN') { non_admin_user.token }
      end

      response(401, description: 'Deny access') do
        let(:'X-AUTH-TOKEN') { 'unknown' }
      end
    end

    delete(summary: 'Destroy user') do
      produces 'application/json'
      tags :users
      let(:id) { "any_id" }

      context "When requested by admin" do
        let(:'X-AUTH-TOKEN') { admin.token }

        response(204, description: 'Destroy requested user') do
          let(:id) { non_admin_user.id }

          it 'User not exists' do
            expect(User.find_by(id: id)).to be_nil
          end
        end

        response(404, description: 'Return unfound') do
          let(:id) { "any_id" }
        end
      end

      response(204, description: 'Destroy user with which token requested') do
        let(:'X-AUTH-TOKEN') { non_admin_user.token }


        it 'User not exists' do
          expect(User.find_by(id: id)).to be_nil
        end
      end

      response(401, description: 'Deny access') do
        let(:'X-AUTH-TOKEN') { 'unknown' }
      end
    end
  end
end
