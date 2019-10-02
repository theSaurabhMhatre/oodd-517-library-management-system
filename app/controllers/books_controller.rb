class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /books
  # GET /books.json
  def index
    if (session[:user_type] == ApplicationController::TYPE_STUDENT)
      if (params[:library_id] != nil)
        @books = Book.fetch_books(params[:library_id])
      else
        # if parameter not specified, redirect to home page saying invalid request
        # TODO: check if msg can be displayed
        redirect_to libraries_path
      end
    else
      @books = Book.fetch_books(nil)
    end
  end

  def filter
    book_name = params[:book_title].nil? ? "" : params[:book_title];
    author_name = params[:book_author].nil? ? "" : params[:book_author];
    if (session[:user_type] == ApplicationController::TYPE_STUDENT)
      if (params[:library_id] != nil)
        @books = Book.filter_books(params[:library_id], book_name, author_name)
      else
        # if parameter not specified, redirect to home page saying invalid request
        # TODO: check if msg can be displayed
        redirect_to libraries_path
      end
    else
      @books = Book.filter_books(nil, book_name, author_name)
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
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
    check = Book.check_if_in_use(@book.id)
    if check == false
      respond_to do |format|
        format.html { redirect_to books_url, notice: 'Book is in use, cannot be deleted' }
      end
    else
      @book.destroy
      respond_to do |format|
        format.html { redirect_to books_url, notice: 'Book was successfully deleted' }
        format.json { head :no_content }
      end
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
