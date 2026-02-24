class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtRevocable

  after_initialize :set_default_role, if: :new_record?

  enum role: { user: 'user', admin: 'admin' }

  has_many :orders, dependent: :destroy

  def set_default_role
    self.role ||= 'user'
  end
end
