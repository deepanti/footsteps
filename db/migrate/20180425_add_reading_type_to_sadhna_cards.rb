class AddReadingTypeToSadhnaCards < ActiveRecord::Migration
  def change
    add_column :sadhna_cards, :reading_type, :string, :default => "Mins"
    add_column :sadhna_cards, :reading_book, :string
  end

end