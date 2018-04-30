class ChangeChadTypeSadhnaCards < ActiveRecord::Migration
  def change
    change_column :sadhna_cards, :chad, :string
  end

end