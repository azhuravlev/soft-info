class PersonWorker
  include Sneakers::Worker
  from_queue "people"

  def work(msg)
    person_data = JSON.parse(msg)
    person = Person.find_or_initialize_by(name: person_data['name'])
    if person
      person.link = person_data['link']
      person.info = person_data['info']
      person.save
    end
    ack!
  rescue StandardError => e
    puts e.message
    requeue!
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end
end