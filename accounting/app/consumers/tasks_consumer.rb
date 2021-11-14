# frozen_string_literal: true

class TasksConsumer < ApplicationConsumer
  def consume
    params_batch.payloads.each do |event|
      event_data = event['data']

      case event['event_name']
      when 'TaskCreated', 'TaskUpdated'
        task = Task.upsert(event_data, unique_by: :public_id, returning: %i[id price]).first
        next unless task["price"].zero?

        Commands::Tasks::Price.call!(Task.find(task["id"]))
      when 'TaskAssigned'
        task = Task.find_by(public_id: event_data['public_id'])
        assignee = User.find_by(public_id: event_data['assignee']['public_id'])
        next unless task && assignee

        task.update!(assignee: assignee)

        Commands::Tasks::Price.call!(task) if task.price.zero?
        Commands::Transactions::Add.call!(task.assignee, task, -task.price)
      when 'TaskCompleted'
        task = Task.find_by!(public_id: event_data['public_id'])

        Commands::Tasks::Price.call!(task) if task.price.zero?
        Commands::Transactions::Add.call!(task.assignee, task, 2 * task.price)
      else
        # store events in DB
      end
    end
  end
end
