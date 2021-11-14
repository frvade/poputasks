# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']
require ::File.expand_path('../config/environment', __FILE__)
Rails.application.eager_load!

# This lines will make Karafka print to stdout like puma or unicorn
if Rails.env.development?
  # Rails.logger.extend(
  #   ActiveSupport::Logger.broadcast(
  #     ActiveSupport::Logger.new($stdout)
  #   )
  # )
end

class AnalyticsKarafka < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
    config.client_id = 'analytics'
    config.batch_consuming = true
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  #Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
  #Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # Uncomment that in order to achieve code reload in development mode
  # Be aware, that this might have some side-effects. Please refer to the wiki
  # for more details on benefits and downsides of the code reload in the
  # development mode

  Karafka.monitor.subscribe(
    Karafka::CodeReloader.new(
      *Rails.application.reloaders
    )
  )

  consumer_groups.draw do
    consumer_group :users do
      topic :"users-stream" do
        consumer UsersConsumer
      end

      topic :"users-role-changes" do
        consumer UsersConsumer
      end

      topic :"users-balance-changes" do
        consumer UsersConsumer
      end
    end

    consumer_group :tasks do
      topic :"tasks-stream" do
        consumer TasksConsumer
      end

      topic :"tasks-lifecycle" do
        consumer TasksConsumer
      end
    end

    consumer_group :transactions do
      topic :"transactions-add" do
        consumer TransactionsConsumer
      end
    end
  end
end

Karafka.monitor.subscribe('app.initialized') do
  # Put here all the things you want to do after the Karafka framework
  # initialization
end

AnalyticsKarafka.boot!
