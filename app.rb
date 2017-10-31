require 'sinatra/base'
require 'pry'

class App < Sinatra::Base
  configure do
    set :carts, {

    }
  end

  post '/cart' do
    req = JSON.parse(request.body.read)
    id = Random.new.rand(100000)

    settings.carts[id.to_s] = Hash.new

    response.status = 201
    {id: id.to_s}.to_json
  end

  post '/cart/:id' do |cart_id|
    cart_item = JSON.parse(request.body.read)
    sku = cart_item['sku']
    price = cart_item['price']

    item_id = Random.new.rand(100000)
    settings.carts[cart_id][item_id] = {
      sku: sku,
      price: price
    }

    response.status = 201
    {id: item_id.to_s}.to_json
  end

  delete '/cart/:cart_id/item/:item_id' do |cart_id, item_id|

    if settings.carts[cart_id][item_id.to_i] then
      settings.carts[cart_id][item_id] = nil
      response.status = 200
    else
      response.status = 404
    end
    nil
  end

  delete '/cart/:cart_id' do |cart_id|
    if settings.carts[cart_id] then
      settings.carts[cart_id] = nil
      response.status = 200
    else
      response.status = 404
    end
    nil
  end

  get '/cart/:cart_id' do |cart_id|
    cart = settings.carts[cart_id]
    subtotal = cart.reduce(0) do |a, b|
      a + b[1][:price]
    end

    sku_map = Hash.new
    cart.each do |item|
      sku = item[1][:sku]
      if sku_map[sku] then
        sku_map[sku] << item
      else
        sku_map[sku] = [item]
      end
    end

    discount = 0
    sku_map.each do |items|
      if items[1].length >= 2 then
        items[1].each do |a|
          discount += (a[1][:price] * 10)
        end
      end
    end

    final_subtotal = ('%.2f' % subtotal).to_f
    final_discount = ('%.2f' % (discount / 100)).to_f
    final_total = final_subtotal - final_discount

    {
      subtotal: final_subtotal,
      discount: final_discount,
      total: final_total,
      items: cart.map do |k, v|
        {
          id: k,
          sku: v[:sku],
          price: ('%.2f' % v[:price]).to_f
        }
      end
    }.to_json
  end
end

def thing
  'yo'
end
