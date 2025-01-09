class RecommendationRepository < ApplicationRepository
  class << self
    def recommendations(per_page: 1000, page: 1)
      Rails.cache.fetch("recommendations:page=#{page},per_page=#{per_page}", expires_in: 1.day) do
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
          .limit(per_page)
          .offset((page - 1) * per_page)


        # Convert subquery to a relation that can be further queried
        JobSeeker
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
          .order("jobseeker_id, job_rank, matching_skill_count DESC")
          .all
          .to_a
      end
    end

    def optimized_recommendations(per_page: 1000, last_jobseeker_id: 1, last_job_rank: 1)
      cache_key = ""

      params = method(__method__).parameters # [[:keyreq, :per_page], [:keyreq, :last_jobseeker_id], ...]
      params.each_with_object({}) do |(_, name), hash|
        cache_key += "#{name}=#{binding.local_variable_get(name)}"
      end

      Rails.cache.fetch("optimized_recommendations:#{cache_key}", expires_in: 1.day) do
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
          .where(optimized_matching_skills_filter(last_jobseeker_id))


        # Convert subquery to a relation that can be further queried
        JobSeeker
          .from(matching_skills_subquery.arel)
          .select(
            "jobseeker_id",
            "jobseeker_name",
            "job_id",
            "job_title",
            "job_rank",
            Arel.sql("CARDINALITY(matching_skills) AS matching_skill_count"),
            "matching_skill_percent"
          )
          .where(Arel.sql(keyset_pagination, last_jobseeker_id:, last_job_rank:))
          .order("jobseeker_id, job_rank, matching_skill_count DESC")
          .limit(per_page)
          .to_a
      end
    end

    def optimized_matching_skills_filter(last_jobseeker_id)
      Arel.sql("job_seekers.id > ?", last_jobseeker_id - 1)
    end

    def keyset_pagination
      <<-SQL.squish
        matching_skill_percent > 0 AND (
        (jobseeker_id, job_rank) > (
          :last_jobseeker_id,
          :last_job_rank
        )
      )
      SQL
    end
  end
end
