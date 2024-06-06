
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values ( ? )', [barber]
		end
	end

end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users"
		 (
		 	"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
 		 	"username" TEXT,
		 	"phone" TEXT,
	 	 	"datestamp" TEXT,
 	 	 	"barber" TEXT,
 	 	 	"color" TEXT
 	 	)'

 	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Barbers"
		 (
		 	"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
 		 	"name" TEXT
 	 	)'

 	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']	
end

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


get '/something' do
	erb :something
end

get '/login' do
	erb :login
end

get '/cont' do
	haml :cont
end

get '/visit' do
	erb :visit
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

	db = get_db
	db.execute 'insert into
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		values
		( ?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]		
	
	erb "<h2>Спасибо вы записаны!</h2>"

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

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc'

	erb :showusers
end






