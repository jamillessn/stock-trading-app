class User < ApplicationRecord
  before_save :set_default_balance
  after_create :send_admin_mail
  has_many :stocks
  scope :for_approval, -> { where(approved: false) }
  validates :email, presence: true, uniqueness: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  

  def approve
    self.approved = true
    self.approved_at = Time.current
    save
  end

  def active_for_authentication? 
    super && approved?
  end 
    
  def inactive_message 
    approved? ? super : :not_approved
  end

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end

  private

  def set_default_balance
    self.default_balance = 10000 
  end

  def set_confirmed_at
    self.confirmed_at = Time.zone.now
  end

end
