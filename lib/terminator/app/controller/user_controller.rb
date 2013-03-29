class UserController < Terminator::App::Controller::ApplicationController
	post '/' do
		@user = User.new(:login => params[:login], :password => params[:password], :password_confirmation => params[:password])
		debugger
		if @user.save
			@user.reset_single_access_token! if @user.single_access_token.blank?
			{:status => 0, :msg => 'created ok', :data => @user}.to_json
		else
			{:status => -1, :msg => 'created failed'}.to_json
		end
	end
end