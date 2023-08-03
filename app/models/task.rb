class Task < ApplicationRecord
  belongs_to :user
  enum priorities: {low: "low", medium: "medium", high: "high"}
  validates :title, presence: true, length: {maximum: 100}

  def status
    @status ||= determine_status
  end

  private

  def determine_status
    completed_at? ? "completed" : "incomplete"
  end
end
