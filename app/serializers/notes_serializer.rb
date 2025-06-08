class NoteSerializer
  include JSONAPI::Serializer

  attribute :title
  attribute :body
end
