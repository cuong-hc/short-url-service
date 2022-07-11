class CreateKeyAvailables < ActiveRecord::Migration[7.0]
  def up
    create_table :key_availables do |t|
      t.string :key_code, null: false, index: true
      t.serial :number_to_convert, null: false
      t.timestamps
    end
    #Generating unique key_codes beforehand and stores them in database.
    ShortenerUrlService.generate_key_code_offline(DateTime.current, DateTime.current + 1)
  end

  def down    
    drop_table :key_availables
  end
  
end
