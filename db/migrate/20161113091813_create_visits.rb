class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|

      t.string :visitor_ip
      t.string :visitor_city
      t.string :visitor_state
      t.string :visitor_country_iso2
      
      t.timestamps
    end

    add_reference :visits, :short_url, foreign_key: true
  end
end
