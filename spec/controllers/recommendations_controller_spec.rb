require 'rails_helper'
require 'shared_contexts/jobs_and_job_seekers'
require 'shared_examples/controllers_with_optimized_pagination'

RSpec.describe RecommendationsController, type: :controller do
  include_context 'jobs_and_job_seekers'
  it_behaves_like 'controllers_with_optimized_pagination'

  describe 'GET #index' do
    context 'recommendations' do
      it 'assigns @recommendations' do
        get :index
        expect(assigns(:recommendations)).to be_an(Array)
        expect(assigns(:recommendations).length).to be > 0
      end
    end

    context 'when RecommendationRepository raises an error' do
      before do
        allow(RecommendationRepository).to receive(:optimized_recommendations).and_raise(StandardError)
      end

      it 'returns HTTP 500 internal server error' do
        get :index
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
