class Species
  include Mongoid::Document
  field :common_name
  field :binomial
  field :notes
  field :seen, :type => Boolean
end
