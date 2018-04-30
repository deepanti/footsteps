class AddTargetRoundsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :target_rounds, :integer
    remove_column :users, :access_token
    remove_column :users, :industry
    remove_column :users, :headline
    remove_column :users, :summary
    remove_column :users, :picture_url
    remove_column :users, :last_name
    remove_column :users, :maiden_name
    remove_column :users, :formatted_name
    remove_column :users, :phonetic_first_name
    remove_column :users, :phonetic_last_name
    remove_column :users, :formatted_phonetic_name
    remove_column :users, :num_connections
    remove_column :users, :num_connections_capped
    remove_column :users, :specialties
    remove_column :users, :public_profile_url
    remove_column :users, :last_modified_timestamp
    remove_column :users, :proposal_comments
    remove_column :users, :interests
    remove_column :users, :languages
    remove_column :users, :date_of_birth
    remove_column :users, :jid
    remove_column :users, :login_type
    remove_column :users, :gender
    remove_column :users, :bg_image_url
    remove_column :users, :presence_status
    remove_column :users, :is_mentor
    remove_column :users, :is_verified
    remove_column :users, :mentor_rating
    remove_column :users, :normal_rating
  end

end