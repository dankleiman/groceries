require 'sinatra'
require 'csv'
require 'pry'

def get_list
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


#suggested data structure
#   sections: [
#   {section: 'Produce', items: []},
#   {section: 'Meat', items: []},
#   {section: 'Dairy', items: []}
# ]





get '/' do
  @items = get_list
  erb :index
end
