module SessionUserHelper
	# sign in session user
	def sign_in(user)
		session[:user_id] = user.id
	end
	# Remember sign in
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end
	# forget remember
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end
	# get current user
	def current_user
		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		elsif cookies.signed[:user_id]
			user = User.find_by(id: cookies.signed[:user_id])
			if user && user.authenticated?(cookies[:remember_token])
				sign_in user
				@current_user = user
			end
		end
	end
	# check signed in
	def signed_in
		!current_user.nil?
	end
	# sign out
	def sign_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end
end
