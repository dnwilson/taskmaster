class TaskSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :due_date, :completed_at, :status, :priority
end
