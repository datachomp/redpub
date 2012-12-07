class InvoiceApp < Sinatra::Base
        set :views, 'views/'
        set :public_folder, 'public/'
        set :haml, :format => :html5


        get "/" do 
                erb :index, :layout => :applayout
        end

        get "/createinvoice/?" do 
                erb :"createinvoice", :layout => :applayout
        end

end