#configure do
#  REDISTOGO_URL = "redis://localhost:6379/"
#  uri = URI.parse(REDISTOGO_URL)
#  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#end

class InvoiceApp < Sinatra::Base
        set :views, 'views/'
        set :public_folder, 'public/'
        set :haml, :format => :html5

redis = Redis.new

        get "/" do 
                erb :index, :layout => :applayout
        end

        get "/createinvoice/?" do 
                erb :"createinvoice", :layout => :applayout
        end

        get "/redisinfo/" do
        	renfo = redis.info
        	renfo.to_s
        end	

end