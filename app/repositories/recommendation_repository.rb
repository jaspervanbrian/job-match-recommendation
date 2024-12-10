class RecommendationRepository < ApplicationRepository
  class << self
    def recommendations(limit: nil)
      # Prepare a subquery to calculate matching skills and percentages
      matching_skills_subquery = JobSeeker
        .select(
          "job_seekers.id AS jobseeker_id",
          "job_seekers.name AS jobseeker_name",
          "jobs.id AS job_id",
          "jobs.title AS job_title",
          # Count matching skills
          Arel.sql(matching_skills_query),
          # Calculate matching skill percentage
          Arel.sql(matching_skill_percent_query),
          Arel.sql(job_rank)
        )
        .joins("CROSS JOIN jobs")
        .where(Arel.sql(skill_exists))


      # Convert subquery to a relation that can be further queried
      recommendations_query = JobSeeker
        .from(matching_skills_subquery.arel.as("matching_skills"))
        .select(
          "jobseeker_id",
          "jobseeker_name",
          "job_id",
          "job_title",
          "job_rank",
          Arel.sql("CARDINALITY(matching_skills) AS matching_skill_count"),
          "matching_skill_percent"
        )
        .where("matching_skill_percent > 0")
        .order("jobseeker_id, matching_skill_percent DESC, job_id")

      return recommendations_query if limit.blank?

      recommendations_query.where("job_rank <= ?", limit)
    end
  end
end
