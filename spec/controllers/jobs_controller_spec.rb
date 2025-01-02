require 'rails_helper'
require 'shared_contexts/jobs_and_job_seekers'
require 'shared_examples/controllers_with_pagination'

RSpec.describe JobsController, type: :controller do
  include_context 'jobs_and_job_seekers'
  it_behaves_like 'controllers_with_pagination'

  RSpec.shared_examples 'jobs' do |method, action, **opts|
    let!(:params) do
      if opts.present? && opts[:params].present?
        instance_exec(&(opts[:params]))
      else
        nil
      end
    end

    context 'jobs' do
      it 'assigns @jobs' do
        if params.present?
          send(method, action, **params)
        else
          send(method, action)
        end

        expect(assigns(:jobs)).to be_an(Array)
        expect(assigns(:jobs).length).to be > 0
      end
    end

    context 'when JobRepository raises an error' do
      before do
        allow(JobRepository).to receive(:jobs).and_raise(StandardError)
      end

      it 'returns HTTP 500 internal server error' do
        if params.present?
          send(method, action, **params)
        else
          send(method, action)
        end
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe 'GET #index' do
    it_behaves_like "jobs", :get, :index
  end

  describe 'GET #show' do
    let!(:id) { jobs.first.id }
    let(:opts) do
      {
        as: :turbo_stream,
        params: { id: id }
      }
    end

    it_behaves_like "jobs", :get, :show, params: -> { opts }

    context 'candidates' do
      it 'assigns @candidates' do
        get :show, as: :turbo_stream, params: { id: id }

        expect(assigns(:candidates)).to be_an(ActiveRecord::Relation)
        expect(assigns(:candidates).length).to be > 0
      end
    end
  end
end
