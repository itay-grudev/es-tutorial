class SearchController < ApplicationController

  def search
    if params[:query]
      @results = Page.search( params[:query] )
    end
  end

end
