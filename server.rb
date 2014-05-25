require 'sinatra'
require 'csv'
require 'pry'

def get_default_list
  items = []
  items_by_section = []
  area_in_store = ['produce', 'meat', 'dairy', 'aisles', 'bakery', 'other']
  CSV.foreach('public/groceries.csv', headers: true, header_converters: :symbol) do |item|
    items << item.to_hash
  end

  i = 0
  area_in_store.each do |section|
  #look at one section at a time and match all items to it
    sorted_items = []
    items.each do |item|
    #for each item, add it to the sorted_items hash for its section
      if item[:section] == section
       sorted_items << item[:item]
      end
    end
    items_by_section << {:section => section, :items => sorted_items}
  end
  items_by_section
end

def get_new_list
  items = []
  CSV.foreach('public/list.csv', headers: true, header_converters: :symbol) do |item|
    items << item
  end
  items
end


get '/' do
  erb :index
end

get '/lists' do
  @items = get_new_list
  erb :'lists/show'
end

get '/new' do
  @items = get_default_list
  # binding.pry
  erb :'lists/new'
end

post '/new' do
  CSV.open('public/list.csv', "w") do |csv|
    csv << ["item"]
    params.each do | item_key, item_value|
    csv << [item_value]
  end

  end
  redirect '/lists'
end


get '/new_item' do
  @items = get_default_list
  erb :'items/new'
end

post '/new_item' do
  item = params[:new_item]
  section = params[:section]
  binding.pry
  CSV.open('public/groceries.csv', "a") {|csv| csv << [item,section]}
  redirect '/new_item'
end

