class SearchController < ApplicationController

  def search
    unless params[:query].blank?
      @results = Page.search( params[:query] )
    end
  end

end
