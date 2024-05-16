class User < ApplicationRecord
  has_many :stocks
  has_many :transactions
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

  private

  def set_confirmed_at
    self.confirmed_at = Time.zone.now
  end

end
