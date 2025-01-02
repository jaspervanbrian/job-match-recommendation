require 'rails_helper'
require 'shared_contexts/jobs_and_job_seekers'

RSpec.describe RecommendationsController, type: :controller do
  describe 'GET #index' do
    include_context 'jobs_and_job_seekers'

    before do
      # Stub jobs_count
      allow(controller).to receive(:jobs_count)
    end

    context 'when page parameter is not provided' do
      it 'returns HTTP 200 success' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'defaults to page 1' do
        get :index
        expect(assigns(:page)).to eq(1)
      end

      it 'assigns @recommendations' do
        get :index
        expect(assigns(:recommendations)).to be_an(Array)
        expect(assigns(:recommendations).length).to be > 0
      end
    end

    context 'when page parameter is provided' do
      it 'returns HTTP 200 success' do
        get :index, params: { page: 2 }
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @page with the provided value' do
        get :index, params: { page: 2 }
        expect(assigns(:page)).to eq(2)
      end
    end

    context 'pagination' do
      context 'when there are no more recommendations available' do
        it 'returns HTTP 200 success and sets @has_next to false' do
          get :index, params: { page: 1_000_000_000 }
          expect(response).to have_http_status(:ok)
          expect(assigns(:has_next)).to be false
        end
      end
    end

    context 'with invalid page parameter' do
      it 'returns HTTP 422 unprocessable entity for negative page numbers' do
        get :index, params: { page: -1 }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns HTTP 422 unprocessable entity for non-numeric page parameter' do
        get :index, params: { page: 'invalid' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when RecommendationRepository raises an error' do
      before do
        allow(RecommendationRepository).to receive(:recommendations).and_raise(StandardError)
      end

      it 'returns HTTP 500 internal server error' do
        get :index
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
