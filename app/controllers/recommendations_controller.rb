class RecommendationsController < ApplicationController
  before_action :jobs_count
  PER_PAGE = 1000

  def index
    @page = params[:page].present? ? params[:page].to_i : 1

    return render status: :unprocessable_entity if @page < 1

    @recommendations = recommendations(page: @page)
    @has_next = @recommendations.length >= PER_PAGE

  rescue StandardError => _
    render status: :internal_server_error
  end

  private

  def recommendations(page:)
    RecommendationRepository.recommendations(page:)
  end
end
