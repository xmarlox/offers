class CreateCoreEntities < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    create_table :users do |t|
      t.string :slug, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.string :gender, null: false
      t.string :birthdate, null: false
      t.integer :age, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    create_table :users_groups, id: false do |t|
      t.belongs_to :user
      t.belongs_to :group
    end

    create_table :groups do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :target_table, null: false
      t.string :target_column, null: false
      t.string :target_value, null: false
      t.string :target_operator, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    create_table :offers_groups, id: false do |t|
      t.belongs_to :offer
      t.belongs_to :group
    end

    create_table :offers do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :description
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users, :slug, unique: true
    add_index :users, %i[username deleted_at], algorithm: :concurrently
    add_index :groups, :slug, unique: true
    add_index :groups, %i[target_table target_column target_value target_operator], unique: true
    add_index :groups, %i[target_table target_column deleted_at], algorithm: :concurrently
    add_index :groups, :deleted_at
    add_index :offers, :slug, unique: true
    add_index :offers, :deleted_at
  end
end
