class AddSadhnaCardToUser < ActiveRecord::Migration
  def change
  	add_reference :sadhna_cards, :user, index: true
  end
end