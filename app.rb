
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
	@error = 'something wrong!'
	erb :about
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	erb :visit
end

get '/something' do
	erb :something
end

get '/login' do
	erb :login
end

get '/cont' do
	haml :cont
end



post '/contacts' do
	require 'pony'
	# Pony.mail(
	#    :name => params[:name],
	#   :mail => params[:mail],
	#   :body => params[:body],
	#   :to => 'mh101@yandex.com',
	#   :subject => params[:name] + " has contacted you",
	#   #:body => params[:message],
	#   :port => '465',
	#   :via => :smtp,
	#   :via_options => { 
	#     :address              => 'smtp.yandex.com', 
	#     :port                 => '465', 
	#     :enable_starttls_auto => true, 
	#     :user_name            => 'mh101@yandex.com', 
	#     :password             => 'Lv-426-napoval9933', 
	#     :authentication       => :plain, 
	#     :domain               => 'localhost.localdomain'
  	# })

	Pony.mail(
		#:from => params[:mail], # зачем :from ???
	  	:to => 'mh101@yandex.ru', 
	  	
	  	:subject => params[:name] + ' has contacted you', 
	  	:body => params[:mail] + ' ' + params[:body], 
	  	:via => :smtp, 
	  	:via_options => {
	      	:address     => 'smtp.gmail.com',
	      	:port                 => '587',
		    :enable_starttls_auto => true,
		    :user_name            => 'xnet141',
		    :password             => 'zwke kkvl svbv jlsr',
		    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
		    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
    	}
	)	


	#@email = params[:email]
	#@textarea     = params[:textarea]

	#f = File.open 'public/contacts.txt', 'a' #режим 'а' значит append, то есть добавить в конец файла
	#f.write "\nemail: #{@email}, message: #{@textarea}<br>"
	#f.close
	redirect '/cont'
end

post '/visit' do
	@username = params[:username]
	@phone     = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]
	
	# хеш
	hh = {  :username => 'Введите имя!!',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(",")

	if @error != ''
		return erb :visit
	end		
	
	erb "Ok, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

post '/login' do
	@userlogin = params[:userlogin]
	@password = params[:password]
	if @userlogin == 'admin' && @password == 'secret'
		erb :secret
	else
		erb :login
	end
end

