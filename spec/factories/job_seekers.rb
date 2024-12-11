FactoryBot.define do
  factory :job_seeker do
    name { Faker::Name.name }
    skills do
      [
        'Ruby', 'Python', 'JavaScript', 'SQL', 'Problem Solving',
        'Communication', 'React', 'Node.js', 'Machine Learning',
        'Cloud Computing'
      ].sample(rand(1..6))
    end
  end
end
