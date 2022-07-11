class CreateShortenerUrls < ActiveRecord::Migration[7.0]
  def up
    create_table :shortener_urls do |t|
      t.string :original_url, null: false
      t.string :key_code, null: false, index: true
      t.datetime :expired_at, null: true
      t.timestamps
    end    
  end

  def down
    drop_table :shortener_urls 
  end  
end
