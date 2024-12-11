require 'rails_helper'

RSpec.describe JobSeeker, type: :model do
  # Validation tests
  describe 'validations' do
    subject { build(:job_seeker) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:skills) }

    context 'when creating a job seeker' do
      it 'is valid with valid attributes' do
        job_seeker = build(:job_seeker)
        expect(job_seeker).to be_valid
      end

      it 'is invalid with an empty name' do
        job_seeker = build(:job_seeker, name: '')
        expect(job_seeker).not_to be_valid
      end

      it 'is invalid with an empty skills' do
        job_seeker = build(:job_seeker, skills: [])
        expect(job_seeker).not_to be_valid
      end
    end
  end


  # Method tests
  describe 'methods' do
    describe '#skill_match_to' do
      let(:job_seeker) { create(:job_seeker) }
      let(:job) { create(:job) }

      context 'with matching skills' do
        let(:shared_skill) { "Ruby" }

        before do
          job_seeker.skills << shared_skill
          job.required_skills << shared_skill
          job.required_skills << "Python"
        end

        it 'calculates skill match percentage correctly' do
          match_percentage = job_seeker.skill_match_to(job)[:matching_skill_percent]
          expect(match_percentage).to be_a(Float)
          expect(match_percentage).to be > 0
        end
      end

      context 'with no matching skills' do
        let(:odd_job) { create(:job, required_skills: ["COBOL"]) }

        it 'returns zero' do
          expect(job_seeker.skill_match_to(odd_job)[:matching_skill_percent]).to eq(0)
        end
      end
    end
  end
end
