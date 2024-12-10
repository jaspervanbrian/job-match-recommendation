class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.string :required_skills, array: true, default: [], null: false
      t.index :required_skills, using: 'gin'

      t.timestamps
    end
  end
end
