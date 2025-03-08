module Api
  class TasksController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    before_action :set_task, only: [:update, :destroy]
  
    # global error handling
    rescue_from StandardError, with: :handle_error

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
    # Detailed logging
    Rails.logger.debug "Create task params: #{params.inspect}"
    
    begin
      @task = current_user.tasks.build(task_params)
      
      if @task.save
        render json: @task, status: :created

      else
        # Log and render validation errors
        Rails.logger.error "Task creation failed: #{@task.errors.full_messages}"
        render json: { 
          errors: @task.errors.full_messages,
          task_params: task_params
        }, status: :unprocessable_entity
      end
    rescue => e
      # Log any unexpected errors
      Rails.logger.error "Unexpected error in task creation: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      render json: { 
        errors: ["Unexpected error: #{e.message}"]
      }, status: :internal_server_error
    end
  end

  private

  def task_params
    params.require(:task).permit(:description, :completed)
  end

  # Global error handler
  def handle_error(exception)
    Rails.logger.error "Unhandled error: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")

    render json: { 
      errors: ["An unexpected error occurred: #{exception.message}"]
    }, status: :internal_server_error
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