# frozen_string_literal: true

class TasksConsumer < ApplicationConsumer
  def consume
    tasks = params_batch.payloads.reduce({}) do |total, event|
      event_data = event['data']
      public_id = event_data['public_id']

      case event.symbolize_keys
      in event_name: 'TaskCreated'
        task = Task.create!(event_data)
        Commands::Tasks::Price.call!(task)
      in event_name: 'TaskUpdated'
        total[public_id] = (total[public_id] || {}).merge(event_data)
      in event_name: 'TaskAssigned'
        assignee = User.find_by!(public_id: event_data['assignee']['public_id'])
        task = Task.find_by!(public_id: event_data['public_id'])
        Commands::Tasks::Price.call!(task) unless task.price
        Commands::Transactions::Add.call!(assignee, task, -task.price)
      in event_name: 'TaskCompleted'
        Commands::Transactions::Add.call!(assignee, task, 2 * task.price)
      else
        # store events in DB
      end

      total
    end

    Task.upsert_all(tasks.values, unique_by: :public_id) if tasks.any?
  end
end
