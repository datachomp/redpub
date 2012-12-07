#our rack file!
require 'rubygems'
require 'sinatra'
require 'haml'
require "./invoice"

set :root, File.dirname(__FILE__)

map "/" do
        run InvoiceApp
end