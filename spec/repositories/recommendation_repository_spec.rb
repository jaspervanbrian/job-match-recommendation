require 'rails_helper'
require 'shared_contexts/jobs_and_job_seekers'

RSpec.describe RecommendationRepository, type: :repository do
  describe '.recommendations' do
    include_context 'jobs_and_job_seekers'

    context 'when fetching recommendations' do
      it 'returns recommendations with matching skills' do
        recommendations = RecommendationRepository.recommendations

        # Check basic expectations
        expect(recommendations).to be_an(Array)
        expect(recommendations.length).to be > 0

        # Verify each recommendation has expected attributes
        recommendations.each do |recommendation|
          expect(recommendation.jobseeker_id).to be_present
          expect(recommendation.jobseeker_name).to be_present
          expect(recommendation.job_id).to be_present
          expect(recommendation.job_title).to be_present
          expect(recommendation.matching_skill_count).to be_an(Integer)
          expect(recommendation.matching_skill_percent).to be_a(BigDecimal)

          # Ensure matching skill percentage is greater than 0
          expect(recommendation.matching_skill_percent).to be > 0
        end
      end

      it 'supports pagination' do
        # Test first page
        first_page = RecommendationRepository.recommendations(per_page: 2, page: 1)
        expect(first_page.length).to eq(2)

        # Test second page
        second_page = RecommendationRepository.recommendations(per_page: 2, page: 2)
        expect(second_page.length).to be > 0

        # Ensure first page and second page are different
        expect(first_page.map(&:job_id)).not_to eq(second_page.map(&:job_id))
      end

      it 'caches recommendations' do
        # Clear any existing cache
        Rails.cache.clear

        # First call should populate the cache
        first_call = RecommendationRepository.recommendations

        # Second call should return cached result
        expect(Rails.cache).to receive(:fetch).and_call_original.once

        second_call = RecommendationRepository.recommendations

        # Verify results are the same
        expect(first_call.map(&:job_id)).to eq(second_call.map(&:job_id))
      end

      context 'when no matching skills exist' do
        before do
          # Remove all skill associations
          JobSeeker.update_all(skills: [])
          Job.update_all(required_skills: [])
        end

        it 'returns an empty result' do
          recommendations = RecommendationRepository.recommendations
          expect(recommendations).to be_empty
        end
      end
    end
  end
end
