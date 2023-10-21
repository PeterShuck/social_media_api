class CreateRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :ratings do |t|
      t.integer :rating
      t.datetime :rated_at
      t.references :user, null: false, foreign_key: true
      t.integer :rater_id, null: false

      t.timestamps
    end
    add_foreign_key :ratings, :users, column: :rater_id
  end
end
