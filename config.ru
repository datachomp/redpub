#our rack file!
require 'bundler'

Bundler.require
require 'sinatra'
require 'sinatra/flash'
require 'redis'
require "./invoice"
require "./customer"
require "./redisadmin"

set :root, File.dirname(__FILE__)

map "/" do
        run InvoiceApp
end

map "/customer" do
        run CustomerApp
end

map "/redisadmin" do
        run RedisAdminApp
end
