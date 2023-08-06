class CreateImportLocks < ActiveRecord::Migration[7.0]
  def change
    create_table :import_locks do |t|
      t.string :job_id
      t.string :email
      t.datetime :completed_at

      t.timestamps
    end
  end
end
