
require 'swagger_helper'

RSpec.describe 'notes', type: :request do

  path '/api/v1/notes' do

    get 'notes' do

      parameter name: :archived,
        in: :query,
        type: :string,
        required: false

      parameter name: :search,
        in: :query,
        type: :string,
        required: false

      let!(:not_actived_note) { Note.create(title: "title", body: "test body1") }
      let!(:actived_note) { Note.create(title: "title archived note", body: "test body actived note", archived: true) }
      let!(:actived_note_id) { actived_note.id }

      response(200, 'list not archived notes') do

        schema type: :object, properties: {
          data: { type: :array, items: { allOf: [ {"$ref" => "#/components/schemas/note" }] } }
        }

        run_test! do |response|
          expect(respose_notes_list(response)).not_to include(actived_note_id)
        end
      end

      response(200, 'list archived notes with search') do

        schema type: :object, properties: {
          data: { type: :array, items: { allOf: [ {"$ref" => "#/components/schemas/note" }] } }
        }

        let(:archived) { 'true' }
        let(:search) { 'actived note' }

        run_test! do |response|
          expect(respose_notes_list(response)).to include(actived_note_id)
        end
      end

    end
    
    post 'Creates a note' do
      consumes 'application/json'

      parameter name: 'note', in: :body, schema: { 
        type: :object, properties: {
          data: {  "$ref" => "#/components/schemas/note"  }
        }
      } 

      response '201', 'blog created' do
        schema type: :object, properties: {
          data: { "$ref" => "#/components/schemas/note" }
        }

        let(:note) { { data: { attributes: { title: 'foo', body: 'bar' } } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:note) { { data: { attributes: { title: 'foo' } } } }
        run_test!
      end
    end
  end

  path '/api/v1/notes/{id}' do
    parameter name: 'id', in: :path, type: :string

    let!(:id) { Note.create(title: "test title", body: "test body").id }

    get 'show note' do
      response(200, 'successful') do
        schema type: :object, properties: {
          data: {  "$ref" => "#/components/schemas/note"  }
        }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'test' }

        run_test!
      end
    end

    patch 'Update note' do
      consumes 'application/json'

      response '200', 'successful' do
        parameter name: 'note_param', in: :body, schema: { 
          type: :object, properties: {
            data: {  "$ref" => "#/components/schemas/note"  }
          }
        } 

        let(:note_param) { { data: { attributes: { title: 'new title' } } } }

        run_test!  do 
          note = Note.find id 
          expect(note.title).to eq('new title')
        end
      end
    end

    delete 'delete note' do
      response(200, 'successful') do
        run_test!
      end
    end
  end

  def respose_notes_list(response)
    body = JSON.parse(response.body)
    notes_list = body['data']
    notes_list.map { |note| note['id'].to_i }
  end
end
