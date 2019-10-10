class BookRequestsController < ApplicationController
  before_action :set_book_request, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /book_requests
  # GET /book_requests.json
  def index
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      if (params[:request_type] != nil)
        # request from user for checked out books
        @book_requests = BookRequest.fetch_student_requests(session[:user_id], params[:request_type])
      else
        flash[:notice] = "Invalid request"
        redirect_to root_path
      end
    when ApplicationController::TYPE_LIBRARIAN
      @book_requests = BookRequest.fetch_requests_by_librarian(session[:user_id])
    when ApplicationController::TYPE_ADMIN
      @book_requests = BookRequest.fetch_special_and_hold_requests
    end
  end

  # GET /book_requests/1
  # GET /book_requests/1.json
  def show
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      check = BookRequest.check_if_authorised?(user_type, current_user.id, params[:id])
      if(check == false)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_LIBRARIAN
      check = BookRequest.check_if_authorised?(user_type, current_user.library_id, params[:id])
      if(check == false)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_ADMIN
      # admin can see any book request
    end
  end

  # GET /book_requests/new
  def new
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      # TODO: is this check really needed?
      if (params[:library_id] != nil and params[:request_type] != nil)
        if params[:request_type] == BookRequest::IS_BOOKMARK
          val = BookRequest.bookmark_book(session[:user_id], params[:book_id], params[:library_id])
          if (val == 1)
            check = 6
          else
            check = 7
          end
        else
          check = BookRequest.checkout_book(session[:user_id], params[:book_id], params[:library_id])
        end
        respond_to do |format|
          case check
          when 0
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Max number of books already issued' }
          when 1
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book request pending with librarian' }
          when 2
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book checked out' }
          when 3
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book unavailable, created a hold request' }
          when 4
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book already checked out' }
          when 5
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book is on hold' }
          when 6
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book bookmarked' }
          when 7
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book already bookmarked' }
          end
        end
      else
        flash[:notice] = "Invalid request"
        redirect_to libraries_path
      end
    else
      # book requests can only be created by students
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    end
  end

  # GET /book_requests/1/edit
  def edit
    # nobody should be able to edit a book request
    flash[:notice] =  "You are not authorised to perform this action"
    redirect_to root_path
  end

  # POST /book_requests
  # POST /book_requests.json
  def create
    @book_request = BookRequest.new(book_request_params)

    respond_to do |format|
      if @book_request.save
        format.html { redirect_to @book_request, notice: 'Book request was successfully created.' }
        format.json { render :show, status: :created, location: @book_request }
      else
        format.html { render :new }
        format.json { render json: @book_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_requests/1
  # PATCH/PUT /book_requests/1.json
  def update
    respond_to do |format|
      if @book_request.update(book_request_params)
        format.html { redirect_to @book_request, notice: 'Book request was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_request }
      else
        format.html { render :edit }
        format.json { render json: @book_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_requests/1
  # DELETE /book_requests/1.json
  def destroy
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      @book_request.destroy
      request_type = params[:request_type]
      respond_to do |format|
        case request_type
        when BookRequest::IS_BOOKMARK
          format.html { redirect_to book_requests_url(:request_type => BookRequest::IS_BOOKMARK), notice: 'Book request was successfully destroyed.' }
        when BookRequest::IS_HOLD
          format.html { redirect_to book_requests_url(:request_type => BookRequest::IS_HOLD), notice: 'Book request was successfully destroyed.' }
        when BookRequest::IS_SPECIAL
          format.html { redirect_to book_requests_url(:request_type => BookRequest::IS_SPECIAL), notice: 'Book request was successfully destroyed.' }
        end
      end
    else
      # book requests can only be destroyed by students
      flash[:notice] = "Invalid request"
      redirect_to root_path
    end
  end

  def approve
    book_request = BookRequest.find(params[:book_request])
    check = BookRequest.approve_special_request(book_request)
    respond_to do |format|
      case check
      when 0
        format.html { redirect_to book_requests_path, :notice => "Book not available" }
      when 1
        format.html { redirect_to book_requests_path, :notice => "Book request accepted" }
      when 2
        format.html { redirect_to book_requests_path, :notice => "Student has issued max allowed books, cannot approve now" }
      end
    end
  end

  def reject
    book_request = BookRequest.find(params[:book_request])
    BookRequest.reject_special_request(book_request)
    respond_to do |format|
      format.html { redirect_to book_requests_path, :notice => "Book request rejected" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book_request
    @book_request = BookRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_request_params
    params.require(:book_request).permit(:book_id, :library_id, :student_id, :request_type)
  end
end
