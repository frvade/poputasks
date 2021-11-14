# frozen_string_literal: true

module Commands
  module Tasks
    module Validators
      class TaskValidator < Resol::Service
        param :task, SmartCore::Types::Protocol::InstanceOf(Task)

        def call
          task.errors.add(:title, "Jira id in title detected") if task.title.match? /[\[\]]/

          task.errors.empty? ? success!(task) : fail!(:invalid)
        end
      end
    end
  end
end