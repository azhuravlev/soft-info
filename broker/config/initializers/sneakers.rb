require 'sneakers'
Sneakers.configure(amqp: ENV['RABBITMQ_URL'],
                   daemonize: false,
                   log: STDOUT,
                   env: ENV['RAILS_ENV'],
                   retry_max_times: 10,
                   retry_timeout: 3 * 60 * 1000)