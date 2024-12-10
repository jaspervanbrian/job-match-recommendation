class Job < ApplicationRecord
  def top_candidates(top: nil)
    matching_skills = required_skills & job_seeker.skills

    {
      matching_skills: matching_skills,
      matching_skill_count: matching_skills.count,
      matching_skill_percent: (matching_skills.count.to_f / required_skills.count * 100).round(2)
    }
  end
end
