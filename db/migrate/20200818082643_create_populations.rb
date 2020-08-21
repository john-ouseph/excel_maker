class CreatePopulations < ActiveRecord::Migration[5.1]
  def change
    create_table :populations do |t|
      t.string :year
      t.string :country
      t.string :continent
      t.string :population
      t.integer :rank

      t.timestamps
    end
  end
end
