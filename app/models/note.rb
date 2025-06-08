class Note < ApplicationRecord
  include SearchCop

  validates :title, :body, presence: true


  search_scope :search do
    attributes :title, :body
  end

end
