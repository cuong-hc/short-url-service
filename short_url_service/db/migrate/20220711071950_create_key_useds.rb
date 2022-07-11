class CreateKeyUseds < ActiveRecord::Migration[7.0]
  def up
    create_table :key_useds do |t|
      t.string :key_code, null: false, index: true
      t.serial :number_to_convert, null: false
      t.timestamps
    end    
  end

  def down    
    drop_table :key_useds
  end
end
