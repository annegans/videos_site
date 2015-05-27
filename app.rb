require 'sinatra'
require 'sinatra/contrib/all'
require 'pg'
require 'pry-byebug'

get '/' do 
  sql = "select * from videos"
  @videos = run_sql(sql)
  erb :index
end

get '/new' do 
  erb :new 
end

post '/' do 
  sql = "insert into videos (title, description, url, genre) values ('#{params[:title]}', '#{params[:description]}', '#{params[:url]}','#{params[:genre]}')"
  run_sql(sql)
  redirect to('/')
end

get '/videos/:id' do
  sql = "select * from videos where id = #{params[:id]}"
  @video = run_sql(sql).first
  erb :show
end

get '/videos/:id/edit' do
  sql = "select * from videos where id = #{params[:id]}"
  @video = run_sql(sql).first
  erb :edit
end

post '/videos/:id/update' do
 sql = "update videos set title = '#{params[:title]}', description = '#{params[:description]}', url = '#{params[:url]}', genre = '#{params[:genre]}' where id = '#{params[:id]} '"
  run_sql(sql)
  redirect to ("/videos/#{params[:id]}")
end

delete '/videos/:id/delete' do
  sql = "delete from videos where id = #{params[:id]}"
  run_sql(sql)
  redirect to('/')
end


private 

def run_sql(sql)
  conn = PG.connect(dbname: 'youtube', host: 'localhost')
  begin
   result = conn.exec(sql)
  ensure
    conn.close
  end
  result
end