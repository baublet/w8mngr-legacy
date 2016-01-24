module SessionsHelper
	
	# Logins in a user
	def login(user)
		session[:user_id] = user.id
	end
	
	# Returns the current logged-in user (if any).
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end
	
	# Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end
	
	# Logs out the current user.
	def logout
		session.delete(:user_id)
		@current_user = nil
	end
end
