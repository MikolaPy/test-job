require 'rails_helper'

RSpec.describe Note, type: :model do
  it "is not valid without a title and body" do
    note = Note.new(title: nil, body: nil)
    expect(note).to_not be_valid
  end

  it "is valid without a title and body" do
    note = Note.new(title: 'title', body: 'body')
    expect(note).to be_valid
  end


  it "is not archived by default" do
    note = Note.new()
    expect(note.archived).to be_falsey
  end
end
