# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample transactions
transactions = [
  {
    amount: 1200.00,
    date: 1.month.ago,
    category: 'hostel',
    description: 'Monthly Rent',
    transaction_type: 'expense'
  },
  {
    amount: 3500.00,
    date: 2.weeks.ago,
    category: 'Stationary',
    description: 'Books, pens, etc',
    transaction_type: 'income'
  },
  {
    amount: 125.75,
    date: 1.week.ago,
    category: 'Khana Peena',
    description: 'Grocery Shopping',
    transaction_type: 'expense'
  },
  {
    amount: 45.50,
    date: 5.days.ago,
    category: 'transport',
    description: 'Gas/Fuel',
    transaction_type: 'expense'
  },
  {
    amount: 85.20,
    date: 3.days.ago,
    category: 'electricity',
    description: 'Electricity Bill',
    transaction_type: 'expense'
  },
  {
    amount: 78.50,
    date: 2.days.ago,
    category: 'Dost',
    description: 'Turna phirna',
    transaction_type: 'expense'
  },
  {
    amount: 14.99,
    date: 1.day.ago,
    category: 'movie',
    description: 'Movie Tickets',
    transaction_type: 'expense'
  }
]

# Only create transactions if there are none yet
if Transaction.count == 0
  transactions.each do |transaction|
    Transaction.create!(transaction)
    puts "Created transaction: #{transaction[:description]}"
  end
  puts "Created #{transactions.size} sample transactions"
end
