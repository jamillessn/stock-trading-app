class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :stocks
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  default_scope { where(admin:false) }
       
  scope :for_approval, -> { where(approved: false) }

  def approve
    self.approved = true
    self.approved_at = Time.current
    save
  end
end
