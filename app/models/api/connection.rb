# == Schema Information
#
# Table name: api_connections
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  token       :string(255)
#  meta_data   :text(65535)
#  device_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Api::Connection < ActiveRecord::Base
  belongs_to :user, class_name: "::User"
  before_create do
    begin
      self.token = Base64.strict_encode64(Devise.friendly_token + user.email).strip
    end while self.class.find_by(token: self.token).present?
  end
end
