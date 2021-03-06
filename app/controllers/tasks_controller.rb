class TasksController < ApplicationController
  before_action :require_login

  def index
    @tasks = current_user.tasks.todo.order(priority: :desc, id: :desc)
  end

  def create
    @task = current_user.tasks.build params.require(:task).permit(:content)

    if @task.save
      head :ok
    else
      head :internal_server_error
    end
  end

  def update
    @task = current_user.tasks.find params[:id]

    if @task.update params.require(:task).permit(:content, :priority)
      head :ok
    else
      head :internal_server_error
    end
  end

  def done
    @task = current_user.tasks.find params[:id]
    @task.completed_at = Time.zone.now

    if @task.save
      head :ok
    else
      head :internal_server_error
    end
  end

  def days
    @tasks = current_user.tasks
              .completing_of_date(params[:start])
              .or(current_user.tasks.todo)
              .order(id: :desc)
  end
end
