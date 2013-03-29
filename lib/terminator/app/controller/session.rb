class Session < Terminator::App::Controller::ApplicationController
	post '/' do
		@user_session = UserSession.new(:login => params[:login], :password => params[:password])
		if @user_session.save
			current_user.reset_single_access_token! if current_user.single_access_token.blank?
			current_user.logincount.incr
			{:status => 0, :msg => 'ok', :data => {:user_credentials => current_user.single_access_token}}
		else
			{:status => -1, :msg => 'authorize failed!'}
		end
	end

	delete '/' do
		current_user.reset_single_access_token!
		render :json => {:status => 0, :msg => 'ok'}
	end
end