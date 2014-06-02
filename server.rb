require 'sinatra'
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
    conn.exec('SELECT items.item, sections.section, items.section_id, items.id FROM items
      JOIN sections ON items.section_id = sections.id')
  end
end

def create_new_list
   db_connection do |conn|
    conn.exec_params("INSERT INTO lists (created_at) VALUES (NOW())")
  end
end

def retrieve_new_list_id
   db_connection do |conn|
    conn.exec_params("SELECT lists.id FROM lists ORDER BY created_at DESC LIMIT 1")
  end
end

def current_list
  db_connection do |conn|
    conn.exec('SELECT items.item, items.id FROM itemlist
                JOIN items ON itemlist.item_id = items.id
                JOIN lists ON itemlist.list_id = lists.id WHERE itemlist.list_id = (select max(list_id) from itemlist)')
  end
end

def add_new_item(item, section_id)
  db_connection do |conn|
    conn.exec_params("INSERT INTO items (item, section_id) VALUES ($1, $2)", [item, section_id])
  end
end

def section_list
  db_connection do |conn|
    conn.exec('SELECT sections.section, sections.id FROM sections')
  end
end

def add_to_list(item_id, list_id)
  db_connection do |conn|
    conn.exec_params("INSERT INTO itemlist (item_id, list_id) VALUES ($1, $2)", [item_id, list_id])
  end
end

############################
#        ROUTES            #
############################

get '/' do
  erb :index
end

get '/lists' do
  @list = current_list
  erb :'lists/show'
end

get '/new' do
  @items = get_all_items
  erb :'lists/new'
end


post '/new' do
  create_new_list
  new_list = retrieve_new_list_id.to_a
  params.each do |item, value|
    add_to_list(value, new_list[0]["id"])
  end
   redirect '/lists'
end


get '/new_item' do
  @items = get_all_items
  @sections = section_list
  erb :'items/new'
end

post '/new_item' do
  item = params[:new_item]
  section_id = params[:section_id]
  add_new_item(item, section_id)
  redirect '/new_item'
end

