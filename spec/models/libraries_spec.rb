require 'rails_helper'

RSpec.describe Library, type: :model do
  describe "Associations" do
    it { should belong_to(:university) }
    it { should have_many(:librarians) }
    it { should have_many(:book_counts) }
    it { should have_many(:book_requests) }
    it { should have_many(:book_histories) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:max_days) && validate_numericality_of(:max_days).is_greater_than(0)}
    it { should validate_presence_of(:overdue_fine) && validate_numericality_of(:overdue_fine).is_greater_than(0)}
    it { should validate_presence_of(:university_id) }
  end

  describe "check_if_authorised? It returns librarian if the user type is librarian and returns the list of libraries if user type is student " do
    user_type="student"
    if user_type.equal?"student" then expects(@libraries.equal?true)
    end
    user_type="librarian"
    if user_type.equal?"librarian" then expects(@librarian.equal?true)
    end
  end

  describe "if delete function is called then, it calls bookHistory and Library" do
    @BookHistory.equal?true
    @library.equal?true
  end
end

