class Transaction < ApplicationRecord
  # Add association to user
  belongs_to :user, optional: true
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :category, presence: true
  validates :description, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  
  # Add a scope for recent transactions
  scope :recent, -> { order(date: :desc).limit(5) }
  
  # Add a scope for expenses
  scope :expenses, -> { where(transaction_type: 'expense') }
  
  # Add a scope for income
  scope :income, -> { where(transaction_type: 'income') }
end
