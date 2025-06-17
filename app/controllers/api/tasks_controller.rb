module Api
class TasksController < ApplicationController
  before_action :validate_user

  def index
    @tasks = current_user.tasks
    @filter = params[:filter] || 'all'
    
    @tasks = case @filter
      when 'active'
        @tasks.where(completed: false)
      when 'completed'
        @tasks.where(completed: true)
      else
        @tasks
      end
      
    respond_to do |format|
      format.html
      format.json { render json: @tasks }
    end
  end

  def create
     # more detailed logging
    Rails.logger.debug "Create task params: #{params.inspect}"

    @task = current_user.tasks.build(task_params)
    
    if @task.save
      render json: @task, status: :created
    else
      # Log the errors
      Rails.logger.error "Task creation failed: #{@task.errors.full_messages}"
      render json: { 
        errors: @task.errors.full_messages,
        task_params: task_params
      }, status: :unprocessable_entity
    end
  end

  def update
    if @task.user == current_user && @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.user == current_user
      @task.destroy
      head :no_content
    else
      head :unauthorized
    end
  end

  private
  
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :completed)
  end
end
end