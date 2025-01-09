class RecommendationsController < ApplicationController
  before_action :jobs_count
  PER_PAGE = 1000

  def index
    last_jobseeker_id = params.fetch(:last_jobseeker_id, 0).to_i
    last_job_rank = params.fetch(:last_job_rank, 0).to_i

    @recommendations = recommendations(
      last_jobseeker_id:,
      last_job_rank:,
    )

    @has_next = @recommendations.length >= PER_PAGE

    last_record = @recommendations.last

    @next_page_params = @has_next ? {
      last_jobseeker_id: last_record.jobseeker_id,
      last_job_rank: last_record.job_rank
    } : {}
  rescue
    render status: :internal_server_error
  end

  private

  def recommendations(**opts)
    RecommendationRepository.optimized_recommendations(per_page: PER_PAGE, **opts)
  end
end
