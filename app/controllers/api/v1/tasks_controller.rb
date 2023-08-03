module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, except: %i[index create]
    
      def index
        @tasks = Task.search(params[:query]).page(params[:page])
        render json: serialized_json(@tasks, paginate), status: :ok
      end
    
      def show
        render json: serialized_json(@task), status: :ok
      end
      
      def create
        @task = Task.new(task_params)
        if @task.save
          render json: serialized_json(@task), status: :created
        else
          render json: { errors: @task.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params)
          render json: serialized_json(@task), status: :ok
        else
          render json: { errors: @task.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
        render json: {}, status: :ok
      end

      private

      def serialized_json(object, options={})
        TaskSerializer.new(object, options).serializable_hash
      end

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task)
              .permit(:title, :description, :user_id, :priority, :due_date, :completed_at)
      end

      def paginate
        {
          meta: {
            current: @tasks.current_page,
            next_page: @tasks.next_page,
            prev_page: @tasks.prev_page,
            total: @tasks.total_count,
            pages: @tasks.total_pages
          }
        }
      end
    end
  end
end