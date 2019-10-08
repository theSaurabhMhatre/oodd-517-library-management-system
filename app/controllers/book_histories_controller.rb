class BookHistoriesController < ApplicationController
  before_action :set_book_history, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /book_histories
  # GET /book_histories.json
  def index
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      if (params[:request_type] == BookHistory::ISSUED)
        @book_histories = BookHistory.fetch_checked_out_books(session[:user_id], BookHistory::ISSUED)
      else
        @book_histories = BookHistory.fetch_checked_out_books(session[:user_id], BookHistory::ALL)
        # TODO: is this what is expected?
        #flash[:notice] =  "Invalid request"
        #redirect_to root_path
      end
    when ApplicationController::TYPE_LIBRARIAN
      @book_histories = BookHistory.where(:library_id => @current_user.library_id)
    when ApplicationController::TYPE_ADMIN
      @book_histories = BookHistory.all
    end
  end

  # GET /book_histories/1
  # GET /book_histories/1.json
  def show
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      check = BookHistory.check_if_authorised?(user_type, current_user.id, params[:id])
      if(check == false)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_LIBRARIAN
      check = BookHistory.check_if_authorised?(user_type, current_user.library_id, params[:id])
      if(check == false)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_ADMIN
      # admin can see any book history
    end
  end

  # GET /book_histories/new
  def new
    # nobody should be able to create a book history but students, via UI
    # @book_history = BookHistory.new
    flash[:notice] =  "You are not authorised to perform this action"
    redirect_to root_path
  end

  # GET /book_histories/1/edit
  def edit
    # nobody should be able to edit a book history
    flash[:notice] =  "You are not authorised to perform this action"
    redirect_to root_path
  end

  # POST /book_histories
  # POST /book_histories.json
  def create
    @book_history = BookHistory.new(book_history_params)

    respond_to do |format|
      if @book_history.save
        format.html { redirect_to @book_history, notice: 'Book history was successfully created.' }
        format.json { render :show, status: :created, location: @book_history }
      else
        format.html { render :new }
        format.json { render json: @book_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_histories/1
  # PATCH/PUT /book_histories/1.json
  def update
    respond_to do |format|
      if @book_history.update(book_history_params)
        format.html { redirect_to @book_history, notice: 'Book history was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_history }
      else
        format.html { render :edit }
        format.json { render json: @book_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_histories/1
  # DELETE /book_histories/1.json
  def destroy
    # TODO: should admin or librarian be allowed to perform this action?
    @book_history.destroy
    respond_to do |format|
      format.html { redirect_to book_histories_url, notice: 'Book history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # get /book_histories/1/return
  def return_book
    @book_history = BookHistory.find(params[:id])
    book_id = @book_history.book_id;
    library_id = @book_history.library_id
    # increment students book_limit
    Student.increment_book_limit(session[:user_id])
    # increment availability of book in book_count
    BookCount.book_count_increment(book_id, library_id)
    BookHistory.return_book(book_id, library_id, session[:user_id])
    # check if there are any holds for this book
    BookRequest.check_hold(book_id, library_id)
    respond_to do |format|
      format.html { redirect_to book_histories_url(:request_type => BookHistory::ISSUED), notice: 'Book returned successfully.' }
      format.json { head :no_content }
    end
  end


  def overdue_fines
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_ADMIN
      @overdue_fines = BookHistory.overdue_books_for_system()
    when ApplicationController::TYPE_LIBRARIAN
      @overdue_fines = BookHistory.overdue_books_for_library(@current_user.library_id)
    when ApplicationController::TYPE_STUDENT
      @overdue_fines = BookHistory.overdue_books_for_student(session[:user_id])
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book_history
    @book_history = BookHistory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_history_params
    params.require(:book_history).permit(:book_id, :library_id, :student_id, :action)
  end
end
