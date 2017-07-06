class CreateConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :connections do |t|
      t.references :user, foreign_key: true
      t.references :machine, foreign_key: true
      t.string :ssh_key
      t.string :passphrase

      t.timestamps
    end
  end
end
