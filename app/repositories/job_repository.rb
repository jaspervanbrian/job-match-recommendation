class JobRepository < ApplicationRepository
  class << self
    def top_candidates(job, top: 10)
      required_skills = job.required_skills

      job_seeker_subquery = JobSeeker
        .select(
          "job_seekers.*",
          # Count matching skills
          Arel.sql(matching_skills_query),
          # Calculate matching skill percentage
          Arel.sql(matching_skill_percent_query)
        )
        .joins("CROSS JOIN jobs")
        .where(Arel.sql(skill_exists))
        .where("jobs.id = ?", job.id)

        JobSeeker
          .from(job_seeker_subquery.arel.as("job_seeker_subquery"))
          .select("*")
          .order("matching_skill_percent DESC, CARDINALITY(skills) DESC, id ASC")
          .limit(top)
    end

    def jobs(page: 1, per_page: 100)
      Job.limit(per_page).offset((page - 1) * per_page)
    end
  end
end
