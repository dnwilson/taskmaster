module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, except: %i[index create]
    
      def index
        @tasks = Task.all
      end
    
      def show
        render json: TaskSerializer.new(@task), status: :ok
      end
      
      def create
        @task = Task.new(task_params)
        if @task.save
          render json: TaskSerializer.new(@task), status: :created
        else
          render json: { errors: @task.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params)
          render json: TaskSerializer.new(@task), status: :ok
        else
          render json: { errors: @task.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
        render json: {}, status: :ok
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task)
              .permit(:title, :description, :user_id, :priority, :due_date, :completed_at)
      end
    end
  end
end