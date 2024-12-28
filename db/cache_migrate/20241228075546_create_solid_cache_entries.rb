# Manually create this file because of issues associated to migrations:
# - https://github.com/rails/solid_queue/issues/329#issuecomment-2366731365
# - https://github.com/rails/solid_queue/issues/419#issuecomment-2503755630

class CreateSolidCacheEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_cache_entries do |t|
      t.binary :key, limit: 1024, null: false
      t.binary :value, limit: 536870912, null: false
      t.datetime :created_at, null: false
      t.integer :key_hash, limit: 8, null: false
      t.integer :byte_size, limit: 4, null: false

      t.index :byte_size
      t.index [:key_hash, :byte_size]
      t.index :key_hash, unique: true
    end
  end
end
