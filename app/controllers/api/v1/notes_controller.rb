class Api::V1::NotesController < ApplicationController
  before_action :set_note, only: %i[ show update destroy ]

  def index
    @notes = Note.where(archived: archived_param).search(search_param)
    @pagy, @notes = pagy(@notes)

    links_hash = pagy_jsonapi_links(@pagy)

    render json: JSONAPI::Serializer.serialize(@notes, links: links_hash, is_collection: true)
  end

  def show 
    render json: JSONAPI::Serializer.serialize(@note)
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      render json: JSONAPI::Serializer.serialize(@note), status: :created
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      render json: 'OK', status: :ok
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy!
    render json: 'OK', status: :ok
  end

  private
    def search_param
      params[:search]
    end

    def archived_param
      params[:archived].present? && params[:archived].downcase == 'true'
    end

    def set_note
      @note = Note.find(params.expect(:id))
    end

    def note_params
      params.require(:data).permit(attributes: [:title, :body])
    end
end
