class HomeController < ApplicationController

  def index
    @species = Species.all
    @seen    = Species.all(:conditions => {:seen => 1})
  end

end
