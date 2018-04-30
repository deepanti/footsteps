class AddVersesToSadhnaCards < ActiveRecord::Migration
  def change
    add_column :sadhna_cards, :verses, :integer
    change_column :sadhna_cards, :chad, 'integer USING CAST(chad AS integer)'
  end

end