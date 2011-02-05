require 'rubygems'
require 'sinatra'
require 'sequel'
require 'erb'

DB = Sequel.connect('sqlite://fecba.db')

DB.create_table? :logins do
    primary_key :id
    String :username
    DateTime :login_date
    DateTime :logout_date
end


get '/' do
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
    if words[0]=="logout"
        sql = "SELECT * FROM logins WHERE username = '#{words[1]}' ORDER BY login_date DESC"
        @login_list=DB.fetch(sql)
        DB.run("UPDATE LOGINS SET logout_date = datetime('now') WHERE id = #{@login_list.first[:id]}")
        sql = "SELECT * FROM logins WHERE username = '#{words[1]}' ORDER BY login_date DESC"
        @login_list=DB.fetch(sql)
        duration = @login_list.first[:logout_date] - @login_list.first[:login_date] 
        @message = "thanks nate, you were logged in for #{duration / 60} minutes."
    end
    erb :index
end

enable :inline_templates

__END__
@@ list
<html>
<body>
<ul>
<%= @message %>
<%= @login_list.first[:login_date] %>|
<%= @login_list.first[:logout_date] %>
<%= %>
<%= (@login_list.first[:logout_date] - @login_list.first[:login_date]).class %>

</ul>
</body>
</html>
