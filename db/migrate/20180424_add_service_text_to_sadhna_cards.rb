class AddServiceTextToSadhnaCards < ActiveRecord::Migration
  def change
    add_column :sadhna_cards, :service_text, :string
  	add_column :sadhna_cards, :slokas_read, :integer
  	add_column :sadhna_cards, :sloka_text, :string
  	add_column :sadhna_cards, :comments, :string
  	add_column :sadhna_cards, :deity_worship, :integer
  	add_column :sadhna_cards, :devotee_associaton, :integer
  end

end