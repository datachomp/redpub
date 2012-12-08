#configure do
#  REDISTOGO_URL = "redis://localhost:6379/"
#  uri = URI.parse(REDISTOGO_URL)
#  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#end

class InvoiceApp < Sinatra::Base
        enable :sessions
        register Sinatra::Flash
        set :views, 'views/'
        set :public_folder, 'public/'
        set :haml, :format => :html5

        redis = Redis.new

        get "/" do 
                redis.incr "visitorreward"
                visitorcount = redis.get "visitorreward"

                if visitorcount.to_i > 4
                   flash.now[:winner] = "You get a free video!"
                   redis.set "visitorreward", 0
                   redis.incr "randomwinnercount"
                end
                
                @randomwinnercount = redis.get "randomwinnercount"
                if @randomwinnercount.empty?
                   @randomwinnercount = 0
                end

                @greeting = redis.get "appgreeting"
                @videos = redis.lrange "vidlist" ,0 ,-1

                erb :index, :layout => :applayout
        end

        get "/createinvoice/?" do 
                erb :"createinvoice", :layout => :applayout
        end

        #dummy URL for looking at output
        get "/blarby/" do 
            @videos = redis.lrange "vidlist" ,0 ,-1
            @videos.inspect
        end

end