namespace :fix do
  desc "Assign transactions to users"
  task assign_users_to_transactions: :environment do
    # Find transactions without users
    unassigned_transactions = Transaction.where(user_id: nil)
    
    if unassigned_transactions.any?
      # Find the first user (or create one if none exists)
      first_user = User.first
      
      if first_user
        puts "Assigning #{unassigned_transactions.count} transactions to user #{first_user.email}"
        
        # Assign all unassigned transactions to the first user
        unassigned_transactions.update_all(user_id: first_user.id)
        
        puts "Successfully assigned transactions."
      else
        puts "No users found. Please create a user first."
      end
    else
      puts "No unassigned transactions found."
    end
  end
end 