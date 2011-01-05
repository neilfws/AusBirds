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
  @seen    = options.species.find(:seen => 1).sort(:common_name, 1)
  haml :list
end

get "/species/*" do
  binomial = params[:splat].first.gsub("_", " ")
  @bird    = options.species.find(:binomial => binomial).first
  haml :species
end

get "/extinct" do
  @extinct = options.species.find(:notes => /extinct/)
  haml :extinct
end

get "/genera" do
  @genera = options.species.find.map {|s| s}.inject(Hash.new(0)) {|h, g| h[g['binomial'].split(" ")[0]] += 1; h}.to_a
  @seen  = options.species.find.map {|s| s}.inject(Hash.new(0)) {|h, g| h[g['binomial'].split(" ")[0]] += g['seen']; h}.to_a
  0.upto(@genera.count - 1) { |i| @genera[i][2] = @seen[i][1]}
  @genera.map! {|e| [e[0], e[1] - e[2], e[2]]}
  @genera = @genera.sort_by { |e| e[2].to_f/e[1]}.reverse[0..19]
  haml :genera
end
