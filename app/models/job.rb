class Job < ApplicationRecord
  validates :title, presence: true
  validates :required_skills, presence: true
end
