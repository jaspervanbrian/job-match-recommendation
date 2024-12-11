class RecommendationsController < ApplicationController
  before_action :jobs_count
  PER_PAGE = 1000

  def index
    @page = params[:page].present? ? params[:page].to_i : 1
    @recommendations = recommendations(page: @page)
    @has_next = @recommendations.length >= PER_PAGE
  end

  private

  def recommendations(page:)
    RecommendationRepository.recommendations(page:)
  end
end
