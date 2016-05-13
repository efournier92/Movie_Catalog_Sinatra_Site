require 'sinatra'
require 'builder'
require 'pg'
require 'pry'

configure :development do
  set :db_config, { dbname: "movies" }
end

configure :test do
  set :db_config, { dbname: "movies_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

def get_actor_info(actor)
  sql_query = %(
    SELECT movies.id, movies.title AS movie, cast_members.character as character
    FROM cast_members
    INNER JOIN actors ON cast_members.actor_id = actors.id
    INNER JOIN movies ON cast_members.movie_id = movies.id
    WHERE actors.name = '#{actor}';
  )
  db_connection do |conn|
    conn.exec(sql_query)
  end
end

def list_actors

  sql_query = "SELECT id, name FROM actors ORDER BY name"

  db_connection do |conn|
    conn.exec(sql_query).values.to_a

  end
end

def list_movies

  sql_query = %(
    SELECT movies.id, movies.title, movies.year, movies.rating, genres.name AS genre, studios.name AS studio FROM movies
    INNER JOIN genres ON movies.genre_id = genres.id
    JOIN studios ON movies.studio_id = studios.id
    ORDER BY movies.title;
  )

  db_connection do |conn|
      conn.exec(sql_query).to_a
    end
end

def get_movie_info(movie)
  sql_query = %(
  SELECT movies.title AS movie, genres.name AS genre, studios.name AS studio
  FROM movies
  JOIN genres ON movies.genre_id = genres.id
  JOIN studios ON movies.studio_id = studios.id
  WHERE movies.title = '#{movie}';
  )
  db_connection do |conn|
    conn.exec(sql_query)
  end
end

get '/' do
  redirect '/actors'
end

get '/actors' do
  @actors = list_actors

  erb :actors
end

get '/actors/:id' do
  @actor_id   = params[:id]
  actor_temp = list_actors.select {|actor| actor[0] == @actor_id }
  @actor_name = actor_temp[0][1]
  @roles      = get_actor_info(@actor_name).to_a

  erb :actor_profile
end


get '/movies' do
  xm = Builder::XmlMarkup.new(:indent => 2)

  @tables = xm.table {
    xm.tr { list_movies.first.keys.each { |key| xm.th(key.capitalize) }}

    list_movies.each { |row| xm.tr { row.values.each { |value| xm.td(value.split.map(&:capitalize).join(' ')) unless value.nil?}}}
  }

  erb :movies
end

get '/movies/:id' do
  @movie_id = params[:id]
  @movie_info = list_movies.select {|movie| movie['id'] == @movie_id }

  erb :movie_profile
end
