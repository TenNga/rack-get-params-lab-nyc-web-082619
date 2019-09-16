class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    else
      resp.write "Path Not Found"
    end
    
    if req.path.match(/cart/)
      if @@cart.any?
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      else 
        resp.write "Your cart is empty"
      end 
    elsif req.path.match(/add/)
      add_item = req.params["item"]
      add_item_if_exist(add_item)
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
  def add_item_if_exist(search_term)
    find_item = @@items.find do |item|
      item == search_term
    end 
    if find_item
      @@cart << find_item
      return "Added #{find_item}"
    else
      return "We don't have that item"
    end
  end
end
