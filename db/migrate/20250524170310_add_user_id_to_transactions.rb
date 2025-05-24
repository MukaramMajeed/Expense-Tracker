class AddUserIdToTransactions < ActiveRecord::Migration[8.0]
  def change
    # First add the column allowing null values for existing records
    add_reference :transactions, :user, null: true, foreign_key: true
    
    # Update the existing records with the first user's ID if needed
    # Only in development to avoid issues in production
    if Rails.env.development?
      reversible do |dir|
        dir.up do
          first_user = execute("SELECT id FROM users ORDER BY id LIMIT 1").to_a.first
          if first_user && first_user['id']
            execute("UPDATE transactions SET user_id = #{first_user['id']} WHERE user_id IS NULL")
          end
        end
      end
    end
  end
end
