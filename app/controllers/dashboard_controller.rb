class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # Get recent transactions for dashboard
    @recent_transactions = current_user.transactions.recent
    
    # Calculate total spent, income, and balance
    @total_spent = current_user.transactions.expenses.sum(:amount) || 0
    @total_income = current_user.transactions.income.sum(:amount) || 0
    @balance = @total_income - @total_spent
    
    # Calculate budget utilization (simplified example)
    @budget_percentage = @total_income > 0 ? ((@total_spent / @total_income) * 100).round : 0
    
    # Get spending breakdown by category
    @spending_by_category = current_user.transactions.expenses
                                       .group(:category)
                                       .sum(:amount)
    
    # Calculate percentages for each category
    total_expenses = @spending_by_category.values.sum
    @category_percentages = {}
    
    if total_expenses > 0
      @spending_by_category.each do |category, amount|
        @category_percentages[category] = ((amount / total_expenses) * 100).round
      end
    end
  end
end
