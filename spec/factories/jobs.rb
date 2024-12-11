FactoryBot.define do
  factory :job do
    title do
      [
        "Frontend Developer",
        "Backend Developer",
        "Fullstack Developer",
        "Machine Learning Engineer",
        "Cloud Architect",
        "Data Analyst",
        "Web Developer"
      ].sample
    end

    required_skills do
      [
        'Ruby', 'Python', 'JavaScript', 'SQL', 'Problem Solving',
        'Communication', 'React', 'Node.js', 'Machine Learning',
        'Cloud Computing'
      ].sample(rand(1..6))
    end
  end
end
