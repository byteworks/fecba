require 'rubygems'
require 'sinatra'
require 'sequel'
require 'erb'

DB = Sequel.connect('sqlite://fecba.db')

DB.create_table? :logins do
    primary_key :id
    String :username
    # DateTime :login_date
    # DateTime :logout_date
end


get '/' do
	if rand(2)== 1
		@picture="fecba_logo_blast.jpg"
	else
		@picture="fecba_logo_rattle.png"
	end
	erb :index
end

get '/list' do
    
    records = ""
    @login_list = DB.fetch( "SELECT * FROM logins" )
    erb :list
        
end

post '/go' do
    words=params["command"].split(" ")
    if words[0]=="login"
        DB.run("INSERT INTO logins (username) VALUES ('bob');")
    end
end

enable :inline_templates

__END__
@@ list
<html>
<body>
<ul>
<% for login in @login_list %>
    <li><%= login[:username] %>&#124;</li>
<% end %>
</ul>
</body>
</html>
