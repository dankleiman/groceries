require 'sinatra'
require 'csv'
require 'pry'
require 'pg'


configure :production do
  set :db_connection_info, {
    host: ENV['DB_HOST'],
    dbname:ENV['DB_DATABASE'],
    user:ENV['DB_USER'],
    password:ENV['DB_PASSWORD']
  }

end

configure :development do
  set :db_connection_info, {dbname: 'groceries'}
end

############################
#       CSV METHODS        #
############################

# def get_default_list
#   items = []
#   items_by_section = []
#   area_in_store = ['produce', 'meat', 'dairy', 'aisles', 'bakery', 'other']
#   CSV.foreach('public/groceries.csv', headers: true, header_converters: :symbol) do |item|
#     items << item.to_hash
#   end

#   i = 0
#   area_in_store.each do |section|
#   #look at one section at a time and match all items to it
#     sorted_items = []
#     items.each do |item|
#     #for each item, add it to the sorted_items hash for its section
#       if item[:section] == section
#        sorted_items << item[:item]
#       end
#     end
#     items_by_section << {:section => section, :items => sorted_items}
#   end
#   items_by_section
# end

# def get_new_list
#   items = []
#   CSV.foreach('public/list.csv', headers: true, header_converters: :symbol) do |item|
#     items << item
#   end
#   items
# end

############################
#        PG METHODS        #
############################

def db_connection
  begin
    connection = PG::Connection.open(settings.db_connection_info)
    yield(connection)
  ensure
    connection.close
  end
end

def get_all_items
  db_connection do |conn|
    conn.exec('SELECT items.item, sections.section, items.section_id FROM items
      JOIN sections ON items.section_id = sections.id')
  end
end

def most_recent_list
  db_connection do |conn|
    conn.exec('SELECT * FROM lists ORDER BY created_at DESC LIMIT 1')
  end
end

def add_new_item(item, section_id)
  db_connection do |conn|
    conn.exec_params("INSERT INTO items (item, section_id) VALUES ($1, $2)", [item, section_id])
  end
end

def section_list
  db_connection do |conn|
    conn.exec('SELECT sections.section FROM sections')
  end

end

############################
#        ROUTES            #
############################

get '/' do
  erb :index
end

get '/lists' do
  @items = most_recent_list
  erb :'lists/show'
end

get '/new' do
  @items = get_all_items
  # binding.pry
  erb :'lists/new'
end

#### REWRITE THIS METHOD TO INSERT A NEW SET OF ITEMS INTO lists ######
post '/new' do
  CSV.open('public/list.csv', "w") do |csv|
    csv << ["item"]
    # INSPECT PARAMS TO SEE WHAT IS BEING CAPTURED
    params.each do | item_key, item_value|
    csv << [item_value]
  end

  end
  redirect '/lists'
end


get '/new_item' do
  @items = get_all_items
  @sections = section_list
  binding.pry
  erb :'items/new'
end

#### REWRITE THIS METHOD TO INSERT A NEW ITEM INTO items ######
post '/new_item' do
  item = params[:new_item]
  section_id = params[:section]
  add_new_item(item, section_id)
  redirect '/new_item'
end

### ADDS ITEM TO CURRENT LIST #######
### REWRITE TO UPDATE MOST RECENT LIST ARRAY #######
post '/temp_item' do
  item = params[:new_item]
  CSV.open('public/list.csv', "a") {|csv| csv << [item]}
  redirect '/lists'
end

