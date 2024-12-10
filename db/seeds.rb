# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
require 'csv'

# Clear existing data to prevent duplicates
puts "🧹 Clearing existing data..."
JobSeeker.delete_all
Job.delete_all

# Import Job seekers
job_seekers_path = Rails.root.join('db', 'data', 'jobseekers.csv')
if File.exist?(job_seekers_path)
  puts "📥 Importing Job seekers from #{job_seekers_path}..."

  JobSeeker.transaction do
    CSV.foreach(job_seekers_path, headers: true) do |row|
      JobSeeker.create!(
        name: row['name'],
        skills: row['skills'].split(', ')
      )
    end
  end

  puts "✅ Imported #{JobSeeker.count} job seekers"
else
  puts "❌ Job seekers CSV not found at #{job_seekers_path}"
end

# Import Jobs
jobs_path = Rails.root.join('db', 'data', 'jobs.csv')
if File.exist?(jobs_path)
  puts "📥 Importing Jobs from #{jobs_path}..."

  Job.transaction do
    CSV.foreach(jobs_path, headers: true) do |row|
      Job.create!(
        title: row['title'],
        required_skills: row['required_skills'].split(', ')
      )
    end
  end

  puts "✅ Imported #{Job.count} jobs"
else
  puts "❌ Jobs CSV not found at #{jobs_path}"
end

# Optional: Generate additional synthetic data
if ENV['GENERATE_SYNTHETIC_DATA'] == 'true'
  puts "🔬 Generating synthetic data..."

  count = ENV['COUNT'].present? ? ENV['COUNT'] : 1000

  JobSeeker.transaction do
    # Additional Job seekers
    count.times do |i|
      skills = [
        'Ruby', 'Python', 'JavaScript', 'SQL', 'Problem Solving',
        'Communication', 'React', 'Node.js', 'Machine Learning',
        'Cloud Computing'
      ].sample(rand(1..6))

      JobSeeker.create!(
        name: Faker::Name.name,
        skills: skills
      )
    end
  end

  Job.transaction do
    # Additional Jobs
    count.times do |i|
      skills = [
        'Ruby', 'Python', 'JavaScript', 'SQL', 'Problem Solving',
        'Communication', 'React', 'Node.js', 'Machine Learning',
        'Cloud Computing'
      ].sample(rand(1..6))

      title = [
        "Frontend Developer",
        "Backend Developer",
        "Fullstack Developer",
        "Machine Learning Engineer",
        "Cloud Architect",
        "Data Analyst",
        "Web Developer"
      ].sample

      Job.create!(
        title:,
        required_skills: skills
      )
    end
  end

  puts "✅ Generated synthetic data"
end

# Print some stats
puts "\n📊 Seeding Complete!"
puts "JobSeekers: #{JobSeeker.count}"
puts "Jobs: #{Job.count}"

# Add a rake task for easy seeding
# lib/tasks/seed_data.rake
namespace :db do
  desc 'Seed jobseekers and jobs from CSV'
  task seed_from_csv: :environment do
    load Rails.root.join('db', 'seeds.rb')
  end
end
