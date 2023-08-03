class Task < ApplicationRecord
  belongs_to :user, optional: true

  enum priorities: {low: "low", medium: "medium", high: "high"}
  validates :title, presence: true, length: {maximum: 100}

  scope :incomplete, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  class << self
    def search(term)
      results = all
      return results if term.blank?

      term = "%#{term.downcase}%"
      results.where("LOWER(tasks.title) LIKE ? OR LOWER(tasks.description) LIKE ?", term, term)
    end
  end

  def status
    @status ||= determine_status
  end

  private

  def determine_status
    completed_at? ? "completed" : "incomplete"
  end
end
