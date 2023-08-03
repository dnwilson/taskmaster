class Task < ApplicationRecord
  belongs_to :user

  enum priorities: %w[low medium high]
end
