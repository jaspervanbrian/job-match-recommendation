require 'rails_helper'

RSpec.describe Job, type: :model do
  # Validation tests
  describe 'validations' do
    subject { build(:job) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:required_skills) }

    context 'when creating a job' do
      it 'is valid with valid attributes' do
        job = build(:job)
        expect(job).to be_valid
      end

      it 'is invalid with an empty title' do
        job = build(:job, title: '')
        expect(job).not_to be_valid
      end

      it 'is invalid with an empty required_skills' do
        job = build(:job, required_skills: [])
        expect(job).not_to be_valid
      end
    end
  end
end
