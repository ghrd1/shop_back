class JwtRevocable < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  self.table_name = 'jwt_revocations'

  def self.jti_for(user)
    user.id.to_s
  end

  def self.revoked?(jti)
    where(jti: jti).exists?
  end

  def self.revoke!(jti)
    where(jti: jti).delete_all
  end
end
