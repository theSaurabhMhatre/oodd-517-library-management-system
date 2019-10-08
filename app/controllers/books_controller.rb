class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /books
  # GET /books.json
  def index
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      if (params[:library_id] != nil)
        @books = Book.fetch_books(params[:library_id])
      else
        # if parameter not specified, redirect to home page saying invalid request
        flash[:notice] = "Please select a library to browse books"
        redirect_to libraries_path
      end
    else
      @books = Book.fetch_books(nil)
    end
  end

  def filter
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      if (params[:library_id] != nil)
        @books = Book.filter_books(params)
      else
        flash[:notice] = "Invalid request"
        redirect_to libraries_path
      end
    else
      @books = Book.filter_books(params)
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      flash[:notice] = "Invalid request"
      redirect_to root_path
    else
      @book = Book.new
    end
  end

  # GET /books/1/edit
  def edit
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      flash[:notice] = "Invalid request"
      redirect_to root_path
    else
      # let admin or librarian edit the book
    end
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    #=begin
    # not using this because the requirement is to delete books and all associated info
    #check = Book.check_if_in_use(@book.id)
    #if check == false
    #  respond_to do |format|
    #    format.html { redirect_to books_url, notice: 'Book is in use, cannot be deleted' }
    #  end
    #end
    #=end
    Book.delete(params[:id])
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully deleted' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:isbn, :title, :author, :language, :published, :edition, :image, :subject, :summary, :is_special)
  end
end
