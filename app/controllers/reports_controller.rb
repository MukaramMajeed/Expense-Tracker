class ReportsController < ApplicationController
  before_action :authenticate_user!
  require 'csv'
  
  def index
    # Default to current month if no date range is specified
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today.end_of_month
    @category = params[:category]
    @transaction_type = params[:transaction_type]
    @report_type = params[:report_type] || 'monthly'
    
    # Fetch transactions based on filters
    @transactions = current_user.transactions.where(date: @start_date..@end_date)
    @transactions = @transactions.where(category: @category) if @category.present?
    @transactions = @transactions.where(transaction_type: @transaction_type) if @transaction_type.present?
    
    # Calculate totals
    @total_income = @transactions.where(transaction_type: 'income').sum(:amount)
    @total_expenses = @transactions.where(transaction_type: 'expense').sum(:amount)
    @net_savings = @total_income - @total_expenses
    
    # Calculate category breakdown for pie chart
    @category_breakdown = @transactions.group(:category).sum(:amount)
    
    # Prepare data for line chart (transactions over time) - simplified approach
    @time_series_data = {}
    
    # Group transactions by date manually - guaranteed to work
    if @transactions.present?
      case @report_type
      when 'monthly'
        # Group by day
        @transactions.each do |t|
          day = t.date.to_date
          @time_series_data[day] ||= 0
          @time_series_data[day] += t.amount
        end
      when 'quarterly'
        # Group by week
        @transactions.each do |t|
          week_start = t.date.beginning_of_week.to_date
          @time_series_data[week_start] ||= 0
          @time_series_data[week_start] += t.amount
        end
      when 'yearly'
        # Group by month
        @transactions.each do |t|
          month_start = t.date.beginning_of_month.to_date
          @time_series_data[month_start] ||= 0
          @time_series_data[month_start] += t.amount
        end
      end
    end
    
    # Ensure we have at least some data points even if empty
    if @time_series_data.empty?
      case @report_type
      when 'monthly'
        # Add some daily data points
        5.times do |i|
          @time_series_data[@start_date + i.days] = 0
        end
      when 'quarterly'
        # Add some weekly data points
        5.times do |i|
          @time_series_data[@start_date + (i*7).days] = 0
        end
      when 'yearly'
        # Add some monthly data points
        5.times do |i|
          month = @start_date >> i # Add i months
          @time_series_data[month] = 0
        end
      end
    end
    
    # Ensure data is sorted by date
    @time_series_data = @time_series_data.sort_by { |date, _| date }.to_h
    
    # Add some test data if in development and no real data exists
    if Rails.env.development? && (@time_series_data.empty? || @time_series_data.values.all?(&:zero?))
      today = Date.today
      
      # Create some realistic test data
      test_data = {
        today - 7.days => 125.50,
        today - 6.days => 74.25,
        today - 5.days => 220.00,
        today - 4.days => 45.75,
        today - 3.days => 89.99,
        today - 2.days => 134.50,
        today - 1.days => 67.25,
        today => 103.99
      }
      
      @time_series_data = test_data
    end
  end
  
  def export_pdf
    # Here you would implement PDF generation logic
    # This is a placeholder for the actual implementation
    # In a real app, you would use a gem like Prawn or wicked_pdf
    
    # Reuse the same filtering logic as in index
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today.end_of_month
    @category = params[:category]
    @transaction_type = params[:transaction_type]
    
    @transactions = current_user.transactions.where(date: @start_date..@end_date)
    @transactions = @transactions.where(category: @category) if @category.present?
    @transactions = @transactions.where(transaction_type: @transaction_type) if @transaction_type.present?
    
    @total_income = @transactions.where(transaction_type: 'income').sum(:amount)
    @total_expenses = @transactions.where(transaction_type: 'expense').sum(:amount)
    @net_savings = @total_income - @total_expenses
    
    # For now, we'll use HTML to PDF approach (browser's print functionality)
    # This renders the PDF template without layout
    render template: "reports/pdf_template", 
           layout: "pdf", 
           formats: [:html]
  end
  
  def download_pdf
    # This action is similar to export_pdf but adds JavaScript to trigger the print dialog
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today.end_of_month
    @category = params[:category]
    @transaction_type = params[:transaction_type]
    
    @transactions = current_user.transactions.where(date: @start_date..@end_date)
    @transactions = @transactions.where(category: @category) if @category.present?
    @transactions = @transactions.where(transaction_type: @transaction_type) if @transaction_type.present?
    
    @total_income = @transactions.where(transaction_type: 'income').sum(:amount)
    @total_expenses = @transactions.where(transaction_type: 'expense').sum(:amount)
    @net_savings = @total_income - @total_expenses
    
    # Set flag to trigger automatic printing
    @auto_print = true
    
    # Render the template with a flag to trigger print dialog
    render template: "reports/pdf_template", 
           layout: "pdf"
  end
  
  def export_csv
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today.end_of_month
    @category = params[:category]
    @transaction_type = params[:transaction_type]
    
    @transactions = current_user.transactions.where(date: @start_date..@end_date)
    @transactions = @transactions.where(category: @category) if @category.present?
    @transactions = @transactions.where(transaction_type: @transaction_type) if @transaction_type.present?
    
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=expense_report_#{Date.today.strftime('%Y%m%d')}.csv"
        
        # Generate CSV data
        csv_data = CSV.generate do |csv|
          csv << ['Date', 'Category', 'Description', 'Amount', 'Type']
          
          @transactions.each do |transaction|
            csv << [
              transaction.date,
              transaction.category,
              transaction.description,
              transaction.amount,
              transaction.transaction_type
            ]
          end
        end
        
        render plain: csv_data
      end
    end
  end
end 