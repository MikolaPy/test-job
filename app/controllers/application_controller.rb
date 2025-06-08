class ApplicationController < ActionController::API
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound, :with => :error_not_found

  def error_not_found
    render json: { error: "Note not found" }, status: :not_found
  end
end
