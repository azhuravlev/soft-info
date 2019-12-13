require 'swagger_helper'

RSpec.describe 'Tools', type: :request, capture_examples: true do
  let!(:tools) { create_list(:tool, 3) }
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, role: 'admin') }

  path '/tools' do
    parameter 'HTTP_X_AUTH_TOKEN', in: :header, type: :string, description: "AUTH token"

    get(summary: 'Get tools') do
      produces 'application/json'
      tags :tools

      response(200, description: 'Return all the available tools for authorized user') do
        let(:'HTTP_X_AUTH_TOKEN') { user.token }

        it 'Return 3 tools' do
          body = JSON(response.body)
          expect(body.count).to eq(3)
        end
      end

      response(401, description: 'Deny access for unknown token') do
        let(:'HTTP_X_AUTH_TOKEN') { "unknown" }
      end
    end

    post(summary: 'Create tool') do
      produces 'application/json'
      consumes 'application/json'
      tags :tools
      parameter :tool,
                in: :body,
                required: true,
                schema: {
                    '$ref' => '#/definitions/tool'
                }

      let(:tool) { { tool: { name: 'tool', repo_url: 'repo' } } }

      response(201, description: 'Creates tool') do
        let(:'HTTP_X_AUTH_TOKEN') { user.token }
      end

      response(422, description: 'Return error for wrong parametrs') do
        let(:'HTTP_X_AUTH_TOKEN') { user.token }
        let(:tool) { { tool: { name: 'tool' } } }

        it 'Returns error' do
          body = JSON(response.body)
          expect(body['repo_url']).to eq(["can't be blank"])
        end
      end

      response(401, description: 'Deny access for unknown token') do
        let(:'HTTP_X_AUTH_TOKEN') { "unknown" }
      end
    end
  end

  path '/tools/{id}' do
    parameter :id, in: :path, type: :integer, required: true, description: 'User ID for admin requests'
    parameter 'HTTP_X_AUTH_TOKEN', in: :header, type: :string, description: "AUTH token"

    get(summary: 'Get tool') do
      produces 'application/json'
      tags :tools

      response(200, description: 'Return requested tool') do
        let(:'HTTP_X_AUTH_TOKEN') { user.token }
        let(:id) { tools.last.id }

        it 'Return tool' do
          body = JSON(response.body)
          expect(body['name']).to eq(tools.last.name)
        end
      end

      response(404, description: 'Return unfound') do
        let(:'HTTP_X_AUTH_TOKEN') { user.token }
        let(:id) { "any_id" }
      end

      response(401, description: 'Deny access') do
        let(:'HTTP_X_AUTH_TOKEN') { 'unknown' }
        let(:id) { tools.last.id }
      end
    end

    put(summary: 'Update tool') do
      produces 'application/json'
      tags :tools
      parameter :tool,
                in: :body,
                required: true,
                schema: {
                    '$ref' => '#/definitions/tool'
                }
      let(:id) { "any_id" }
      let(:tool) { { tool: { name: 'tool', repo_url: 'repo' } } }

      response(204, description: 'Updates requested tool by admin') do
        let(:'HTTP_X_AUTH_TOKEN') { admin.token }
        let(:id) { tools.last.id }
      end

      response(404, description: 'Return unfound') do
        let(:'HTTP_X_AUTH_TOKEN') { admin.token }
        let(:id) { "any_id" }
      end

      response(401, description: 'Deny access') do
        let(:'HTTP_X_AUTH_TOKEN') { 'unknown' }
        let(:id) { tools.last.id }
      end
    end

    delete(summary: 'Destroy tool') do
      produces 'application/json'
      tags :tools
      let(:id) { tools.last.id }

      response(204, description: 'Destroy tool if admin request') do
        let(:'HTTP_X_AUTH_TOKEN') { admin.token }

        it 'Tool not exists' do
          expect(Tool.find_by(id: id)).to be_nil
        end
      end

      response(404, description: 'Return unfound') do
        let(:'HTTP_X_AUTH_TOKEN') { admin.token }

        let(:id) { "any_id" }
      end

      response(401, description: 'Deny access for user') do
        let(:'HTTP_X_AUTH_TOKEN') { user.token }
      end
    end
  end
end
