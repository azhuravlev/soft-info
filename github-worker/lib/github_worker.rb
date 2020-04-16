require 'octokit'
require 'sneakers'
require 'sneakers/worker'

class GithubWorker
  include Sneakers::Worker
  from_queue "tools"

  def work(msg)
    tool_data = JSON.parse(msg)
    repo = tool_data['repo_url'].gsub('://', '').split('/')[1..-1].join('/')
    contributors = github_client.contributors(repo)
    contributors.each do |c|
      data = {
          name: c.login,
          link: c.url,
          info: c.to_hash
      }
      Sneakers.publish(data.to_json, to_queue: "people")
    end
    ack!
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end
end