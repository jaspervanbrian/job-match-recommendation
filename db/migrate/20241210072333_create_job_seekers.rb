class CreateJobSeekers < ActiveRecord::Migration[8.0]
  def change
    create_table :job_seekers do |t|
      t.string :name, null: false
      t.string :skills, array: true, default: [], null: false
      t.index :skills, using: 'gin'

      t.timestamps
    end
  end
end
