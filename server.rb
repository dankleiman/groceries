require 'sinatra'
require 'csv'


def get_list
  items = []
  CSV.foreach('public/groceries.csv', headers: true, header_converters: :symbol) do |item|
    items << item.to_hash
  end
  items
end



get '/' do
  @items = get_list
  erb :index
end
