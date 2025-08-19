class Quest < ApplicationRecord
  validates :title, presence: true

  scope :completed, -> { where(done: true) }
  scope :pending, -> { where(done: [ false, nil ]) }
end
