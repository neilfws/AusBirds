class SpeciesController < ApplicationController

  def index
    @species = Species.all(:conditions => {:seen => 1})
  end

end
