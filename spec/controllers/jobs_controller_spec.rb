require 'rails_helper'
require 'shared_contexts/jobs_and_job_seekers'
require 'shared_contexts/controllers_with_pagination'

RSpec.describe JobsController, type: :controller do
  include_context 'jobs_and_job_seekers'
  include_context 'controllers_with_pagination'

  RSpec.shared_examples 'jobs' do
    context 'jobs' do
      it 'assigns @jobs' do
        get :index
        expect(assigns(:jobs)).to be_an(Array)
        expect(assigns(:jobs).length).to be > 0
      end
    end

    context 'when JobRepository raises an error' do
      before do
        allow(JobRepository).to receive(:jobs).and_raise(StandardError)
      end

      it 'returns HTTP 500 internal server error' do
        get :index
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe 'GET #index' do
    include_examples "jobs"
  end

  describe 'GET #show' do
    include_examples "jobs"

    context 'candidates' do
      let(:first_job_id) { Job.first.id }

      it 'assigns @candidates' do
        get :show, as: :turbo_stream, params: { id: first_job_id }
        expect(assigns(:jobs)).to be_an(Array)
        expect(assigns(:jobs).length).to be > 0
      end
    end
  end
end
