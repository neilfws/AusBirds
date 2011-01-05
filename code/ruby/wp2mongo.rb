#!/usr/bin/ruby

require "rubygems"
require "mongo"
require "open-uri"
require "hpricot"

db    = Mongo::Connection.new.db('birds')
col   = db.collection('species')
birds = Hpricot(open("http://en.wikipedia.org/wiki/List_of_Australian_Birds"))

(birds/"//table[@class='wikitable']/tr").each do |row|
  species = {}
  cells = row.search("td")
  if cells.any?
    species['_id']         = cells[1].inner_text
    species['common_name'] = cells[0].inner_text
    species['binomial']    = cells[1].inner_text
    species['notes']       = cells[2].inner_text
    species['seen']        = 0
    col.save(species)
  end
end

puts "Collection species contains #{col.count} records."
