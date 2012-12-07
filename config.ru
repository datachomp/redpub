#our rack file!
require 'rubygems'
require 'sinatra'
require 'redis'
require "./invoice"

set :root, File.dirname(__FILE__)

map "/" do
        run InvoiceApp
end