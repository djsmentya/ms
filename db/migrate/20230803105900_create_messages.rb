class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :subject
      t.text :sender
      t.datetime :delivered_at
      t.text :body

      t.timestamps
    end
  end
end
