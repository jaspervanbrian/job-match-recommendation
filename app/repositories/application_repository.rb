class ApplicationRepository
  class << self
    def matching_skills_query
      <<-SQL.squish
        ARRAY(
          SELECT UNNEST(job_seekers.skills)
          INTERSECT
          SELECT UNNEST(jobs.required_skills)
        ) AS matching_skills
      SQL
    end

    def calculate_skill_percentage
      <<-SQL.squish
        (
          SELECT COUNT(*)
          FROM UNNEST(job_seekers.skills) AS skill
          WHERE skill = ANY(jobs.required_skills)
        ) * 100.0 / NULLIF(CARDINALITY(jobs.required_skills), 0)
      SQL
    end

    # Query to calculate skill matches percentage
    def matching_skill_percent_query
      <<-SQL.squish
        ROUND(#{calculate_skill_percentage}, 2) AS matching_skill_percent
      SQL
    end

    # Job rank query
    def job_rank
      <<-SQL.squish
        DENSE_RANK() OVER (
          PARTITION BY job_seekers.id
          ORDER BY #{calculate_skill_percentage} DESC, jobs.id ASC
        ) AS job_rank
      SQL
    end

    # Ensure at least 1 skill matches between a job seeker and a job
    def skill_exists
      <<-SQL.squish
        EXISTS (
          SELECT 1
          FROM UNNEST(job_seekers.skills) skill
          WHERE skill = ANY(jobs.required_skills)
        )
      SQL
    end
  end
end
