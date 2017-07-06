class CreateMachines < ActiveRecord::Migration[5.1]
  def change
    create_table :machines do |t|
      #---For SSH-connection----#
      t.string :ssh_user, null: false
      t.string :ssh_host, null: false
      #-------------------------#
      t.string :cpu
      t.integer :number_of_cores
      t.float :cpu_max_freq
      t.string :kernel
      t.string :hostname
      t.string :architecture
      t.float :memory_total
      t.float :memory_used
      t.string :memory_type

      t.timestamps
    end
  end
end
