require 'rubygems'
require 'bundler'
require 'buttercms-ruby'
require "sinatra/content_for"

Bundler.require

ButterCMS::api_token = "b60a008584313ed21803780bc9208557b3b49fbb"

class App < Sinatra::Base
  # http://www.sinatrarb.com/contrib/content_for.html
  helpers Sinatra::ContentFor

  get '/' do
    params[:page] ||= 1

    @posts = ButterCMS::Post.all(:page => params[:page], :page_size => 10)
    @next_page = @posts.meta.next_page
    @previous_page = @posts.meta.previous_page

    erb :index
  end

  get '/post/:slug' do
    @post = ButterCMS::Post.find(params[:slug])

    erb :post
  end

  get '/author/:slug' do
    @author = ButterCMS::Author.find(params[:slug], :include => :recent_posts)

    erb :author
  end

  get '/category/:slug' do
    @category = ButterCMS::Category.find(params[:slug], :include => :recent_posts)

    erb :category
  end

  get '/rss' do
    content_type 'text/xml'

    rss_feed = ButterCMS::Feed.find(:rss).data
  end

  get '/atom' do
    content_type 'text/xml'

    atom_feed = ButterCMS::Feed.find(:atom).data
  end

  get '/sitemap' do
    content_type 'text/xml'

    sitemap = ButterCMS::Feed.find(:sitemap).data
  end
end
