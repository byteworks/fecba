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
