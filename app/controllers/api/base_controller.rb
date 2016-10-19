class Api::BaseController < ActionController::Base

	def current_user
		@user ||= begin
            if (@connection = Api::Connection.find_by(token: request.headers["Authorization"])).present?
              @user = @connection.user
            else
              nil 
            end
          end
	end

end
