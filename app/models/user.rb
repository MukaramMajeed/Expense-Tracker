class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Add association to transactions
  has_many :transactions, dependent: :destroy
  
  # Currency preference options
  CURRENCY_OPTIONS = {
    'USD' => '$',
    'EUR' => '€',
    'SAR' => '﷼',
    'INR' => '₨'
  }
  
  def currency_symbol
    CURRENCY_OPTIONS[currency_preference] || '$'
  end
  
  # Allow updating certain attributes without password
  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
      
      clean_up_passwords
      update(params, *options)
    else
      super
    end
  end
end
