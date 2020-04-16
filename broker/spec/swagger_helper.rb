require 'rspec/rails/swagger'
require 'rails_helper'

RSpec.configure do |config|
  # Specify a root directory where the generated Swagger files will be saved.
  config.swagger_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and global metadata for each.
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      basePath: '/api/v1',
      definitions: {
          user: {
              type: :object,
              properties: {
                  user: {
                      type: :object,
                      properties: {
                          email: { type: :string, example: 'test@test.test' }
                      }
                  }
              }
          },
          tool: {
              type: :object,
              properties: {
                  tool: {
                      type: :object,
                      properties: {
                          name: { type: :string, example: 'SuperTool' },
                          repo_url: { type: :string, example: 'gitrepo.url/tool' }
                      }
                  }
              }
          },
          person: {
              type: :object,
              properties: {
                  tool: {
                      type: :object,
                      properties: {
                          name: { type: :string, example: 'Best Person' },
                          link: { type: :string, example: 'gitPerson.url' },
                          info: { type: :object }
                      }
                  }
              }
          }
      }
    }
  }
end
