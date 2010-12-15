#!/usr/bin/ruby

require "rubygems"
require "fastercsv"
require "mongo"

DB   = Mongo::Connection.new.db('birds')
col  = DB.collection('species')
data = "#{ENV['HOME']}/Dropbox/projects/birds/data/ausbirds.csv"

FasterCSV.read(data, :headers => true).each do |record|
  record = record.to_hash
  record['_id']  = record['Binomial']
  record['seen'] = 0
  col.save(record)
end

puts "Saved #{col.count} records in collection: species."
