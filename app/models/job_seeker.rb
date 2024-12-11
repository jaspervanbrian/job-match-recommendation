class JobSeeker < ApplicationRecord
  validates :name, presence: true
  validates :skills, presence: true

  def skill_match_to(job)
    matching_skills = skills & job.required_skills

    {
      matching_skills: matching_skills,
      matching_skill_count: matching_skills.count,
      matching_skill_percent: (matching_skills.count.to_f / job.required_skills.count * 100).round(2)
    }
  end
end
