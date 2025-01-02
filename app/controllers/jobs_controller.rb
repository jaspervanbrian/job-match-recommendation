class JobsController < ApplicationController
  before_action :jobs_count, :init_jobs
  PER_PAGE = 100

  def index
  end

  def show
    @candidates = top_candidates
  end

  private

  def init_jobs
    @page = params[:page].present? ? params[:page].to_i : 1

    return render status: :unprocessable_entity if @page < 1

    @jobs = jobs(page: @page)
    @has_next = @jobs.length >= PER_PAGE

  rescue
    render status: :internal_server_error
  end

  def jobs(page:)
    JobRepository.jobs(page:)
  end

  def top_candidates
    JobRepository.top_candidates(Job.find(params[:id]))
  end
end
