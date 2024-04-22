class User < ApplicationRecord


   has_many :stocks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :stocks
  after_create :send_admin_mail
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  default_scope { where(admin:false) }

  scope :for_approval, -> { where(approved: false) }

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

  def admin?
    admin
  end

end
