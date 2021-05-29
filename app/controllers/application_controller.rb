class ApplicationController < ActionController::API
  def pages
    if params[:page].nil? || params[:page].to_i <= 0
      1
    else
      params.fetch(:page, 1).to_i
    end
  end

  def results_per_page_request
    if params[:per_page].nil? || params[:per_page].to_i <= 0
      20
    else
      params[:per_page].to_i
    end
  end
end
