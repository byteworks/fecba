require 'sinatra'
require 'erb'
get '/' do
	if rand(2)== 1
		@picture="fecba_logo_blast.jpg"
	else
		@picture="fecba_logo_rattle.png"
	end
	erb :index
end
post '/go' do
	words=params["command"].split(" ")
	if words[0]=="log-in"
		"literrally#{words[1]}"
	end
end
