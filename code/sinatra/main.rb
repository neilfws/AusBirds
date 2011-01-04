configure do
  DB = Mongo::Connection.new.db('birds')
  species = DB.collection('species')
  set :species, species
end

get "/" do
  @seen    = options.species.find(:seen => 1)
  @unseen  = options.species.find(:seen => 0)
  haml :index
end

post "/add" do
  common_name  = params[:common_name]
  seen         = params[:seen]
  bird         = options.species.find(:common_name => common_name).first
  bird['seen'] = seen.to_i
  options.species.save(bird)
  redirect "/"
end

post "/remove" do
  common_name  = params[:common_name]
  seen         = params[:seen]
  bird         = options.species.find(:common_name => common_name).first
  bird['seen'] = seen.to_i
  options.species.save(bird)
  redirect "/"
end

post "/search" do
  common_name  = params[:common_name]
  bird         = options.species.find(:common_name => common_name).first
  binomial     = bird['binomial'].gsub(/\s+/, "_")
  redirect "/species/#{binomial}"
end

post "/edit" do
  bird = {"_id" => params[:binomial], "binomial" => params[:binomial], "common_name" => params[:common_name],
          "notes" => params[:notes], "seen" => params[:seen].to_i}
  options.species.save(bird)
  redirect "/"
end

get "/list" do
  @seen    = options.species.find(:seen => 1)
  # @results = options.species.find(:seen => 1)
  # @seen = WillPaginate::Collection.create(1, per_page=10, @results.count) do |p|
  #  p.replace(@results.to_a)
  # end
  haml :list
end

get "/species/*" do
  binomial = params[:splat].first.gsub("_", " ")
  @bird    = options.species.find(:binomial => binomial).first
  haml :species
end
