require 'rubygems'
require 'sinatra'
require 'sequel'
require 'erb'

DB = Sequel.connect('sqlite://fecba.db')

DB.create_table? :logins do
    primary_key :id
    String :username
    DateTime :login_date
    # DateTime :logout_date
end


get '/' do
    if rand(2)== 1
        @picture="fecba_logo_blast.jpg"
    else
        @picture="fecba_logo_rattle.png"
    end
    @message = ""
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
        sql = "INSERT INTO logins (username, login_date) " +
              "VALUES ('#{words[1]}', datetime('now'));"
        DB.run(sql)
        @message = "#{words[1]} logged in successfully"
    end
    erb :index
end

enable :inline_templates

__END__
@@ list
<html>
<body>
<ul>
<% for login in @login_list %>
    <li><%= login[:username] %>&#124;<%= login[:login_date]%></li>
<% end %>
</ul>
</body>
</html>
