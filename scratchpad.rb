require 'csv'


items = []
items_by_section = []
area_in_store = ['produce', 'meat', 'dairy', 'aisles', 'bakery', 'other']
CSV.foreach('public/groceries.csv', headers: true, header_converters: :symbol) do |item|
  items << item.to_hash
end
# puts items.inspect
i = 0
area_in_store.each do |section|
  #look at one section at a time and match all items to it
  sorted_items = []
  items.each do |item|

    #for each item, add it to the sorted_items hash for its section
#     # binding.pry
    if item[:section] == section
     sorted_items << item[:item]
    end
  end
  items_by_section << {:section => section, :items => sorted_items}
end
puts items_by_section.inspect


