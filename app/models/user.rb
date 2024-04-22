class User < ApplicationRecord


   has_many :stocks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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
