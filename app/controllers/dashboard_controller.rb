class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # Get recent transactions for dashboard
    @recent_transactions = Transaction.recent
    
    # Calculate total spent, income, and balance
    @total_spent = Transaction.expenses.sum(:amount)
    @total_income = Transaction.income.sum(:amount)
    @balance = @total_income - @total_spent
    
    # Calculate budget utilization (simplified example)
    @budget_percentage = ((@total_spent / @total_income) * 100).round if @total_income > 0
    
    # Get spending breakdown by category
    @spending_by_category = Transaction.expenses
                                       .group(:category)
                                       .sum(:amount)
    
    # Calculate percentages for each category
    total_expenses = @spending_by_category.values.sum
    @category_percentages = {}
    
    @spending_by_category.each do |category, amount|
      @category_percentages[category] = ((amount / total_expenses) * 100).round if total_expenses > 0
    end
  end
end
