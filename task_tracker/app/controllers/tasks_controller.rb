# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!, only: %i[new create edit update]
  before_action :set_task, only: %i[show edit update complete]

  # GET /tasks or /tasks.json
  def index
    tasks_dataset = Task.order(:id)
    tasks_dataset = tasks_dataset.where(assignee: current_user) unless current_user.admin?
    @tasks = tasks_dataset.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    result = Commands::Tasks::Add.call(@task)
    if result.success?
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    result = Commands::Tasks::Update.call(@task, task_params)
    if result.success?
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    result = Commands::Tasks::Complete.call(@task, actor: current_user)
    if result.success?
      redirect_to tasks_path, notice: "Task was successfully completed."
    else
      error = nil
      result.value_or { |e| error = "You aren't allowed to complete this task" if e.code == :forbidden }
      redirect_to tasks_path, alert: error
    end
  end

  private

  def check_admin!
    redirect_back(fallback_location: tasks_path, alert: "Forbidden") unless current_user.admin?
  end

  def employees
    User.where(role: :employee).all
  end
  helper_method :employees

  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :assignee_id)
  end
end
