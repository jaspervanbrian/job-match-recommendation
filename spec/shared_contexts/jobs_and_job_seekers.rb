RSpec.shared_context 'jobs_and_job_seekers' do
  let!(:job_seekers) { create_list(:job_seeker, 10) }
  let!(:jobs) { create_list(:job, 10) }
  let!(:skills) do
    [
      'Ruby', 'Python', 'JavaScript', 'SQL', 'Problem Solving',
      'Communication', 'React', 'Node.js', 'Machine Learning',
      'Cloud Computing'
    ]
  end

  before do
    # Create skill associations
    job_seekers.each do |job_seeker|
      # Assign some skills to job seekers
      job_seeker.skills << skills.sample(2)
    end

    jobs.each do |job|
      # Assign some skills to jobs
      job.required_skills << skills.sample(2)
    end
  end
end
