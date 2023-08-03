class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            length: {maximum: 255}, uniqueness: true

  def self.with_tasks_by_prority
    joins(:tasks)
    .select(`
      users.id,
      users.name,
      SELECT COUNT(t1.id)
        FROM tasks t1
        INNER JOIN t1.user_id = users.id
        WHERE t1.completed_at IS NOT NULL
        AS completed,
      SELECT COUNT(*)
        FROM tasks t2
        INNER JOIN t2.user_id = users.id
        WHERE t2.completed_at IS NULL
        AS incomplete
    `)
    .group("users.id, tasks.priority")
  end
end
