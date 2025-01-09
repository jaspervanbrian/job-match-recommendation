RSpec.shared_examples 'controllers_with_optimized_pagination' do
  before do
    # Stub jobs_count
    allow(controller).to receive(:jobs_count)
  end

  context 'when last_jobseeker_id parameter is not provided' do
    it 'returns HTTP 200 success' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when last_jobseeker_id parameter is provided' do
    it 'returns HTTP 200 success' do
      get :index, params: { last_jobseeker_id: 2 }
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when last_job_rank parameter is not provided' do
    it 'returns HTTP 200 success' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when last_job_rank parameter is provided' do
    it 'returns HTTP 200 success' do
      get :index, params: { last_job_rank: 2 }
      expect(response).to have_http_status(:ok)
    end
  end
end
