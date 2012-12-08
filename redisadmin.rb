#configure do
#  REDISTOGO_URL = "redis://localhost:6379/"
#  uri = URI.parse(REDISTOGO_URL)
#  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#end

class RedisAdminApp < Sinatra::Base
        enable :sessions
        register Sinatra::Flash
        set :views, 'views/'
        set :public_folder, 'public/'

redis = Redis.new

        get "/seeddata/?" do 
            redis.flushdb
            redis.set "appgreeting", "Welcome Users!"

            redis.set "visitorreward", 0
            redis.set "randomwinnercount", 0
            redis.rpush "vidlist", "Postgres"
            redis.rpush "vidlist", "RavenDB"
            redis.rpush "vidlist", "SQL Server"

            'data has been seeded'
        end

        get "/" do
        	renfo = redis.info
        	renfo.to_s
        end	

        #dummy URL for looking at output
        get "/blarby/" do 
            @videos = redis.lrange "vidlist" ,0 ,-1
            @videos.inspect
        end

end