class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = current_user.transactions

    # Apply date range filter
    if params[:start_date].present?
      @transactions = @transactions.where("date >= ?", params[:start_date])
    end
    
    if params[:end_date].present?
      @transactions = @transactions.where("date <= ?", params[:end_date])
    end

    # Apply category filter
    if params[:category].present?
      @transactions = @transactions.where(category: params[:category])
    end

    # Apply transaction type filter
    if params[:transaction_type].present?
      @transactions = @transactions.where(transaction_type: params[:transaction_type])
    end

    # Order by date descending
    @transactions = @transactions.order(date: :desc)
  end

  def show
  end

  def new
    @transaction = current_user.transactions.build
    @transaction.date = Date.today
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user
    
    if @transaction.save
      redirect_to transactions_path, notice: "Transaction was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: "Transaction was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_path, notice: "Transaction was successfully deleted."
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :date, :category, :description, :transaction_type)
  end
end 