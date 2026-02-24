class CreateJwtRevocations < ActiveRecord::Migration[7.1]
  def change
    create_table :jwt_revocations do |t|
      t.string :jti, null: false
      t.references :user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :jwt_revocations, :jti, unique: true
  end
end
