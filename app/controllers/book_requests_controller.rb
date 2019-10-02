class BookRequestsController < ApplicationController
  before_action :set_book_request, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /book_requests
  # GET /book_requests.json
  def index
    if (session[:user_type] == ApplicationController::TYPE_STUDENT)
      if (params[:request_type] != nil)
        # request from user for checked out books
        @book_requests = BookRequest.fetch_student_requests(session[:user_id], params[:request_type])
      else
        # if parameter not specified, redirect to home page saying invalid request
        # TODO: check if msg can be displayed
        redirect_to root_path
      end
    elsif (session[:user_type] == ApplicationController::TYPE_LIBRARIAN)
      @book_requests = BookRequest.fetch_requests_by_librarian(session[:user_id])
    elsif (session[:user_type] == ApplicationController::TYPE_ADMIN)
      @book_requests = BookRequest.all
    end
  end

  # GET /book_requests/1
  # GET /book_requests/1.json
  def show
  end

  # GET /book_requests/new
  def new
    if (session[:user_type] == ApplicationController::TYPE_STUDENT)
      # request has come from user
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
            format.html { redirect_to books_path(:library_id => params[:library_id]), notice: 'Book request pending with admin' }
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
      end
    else
      # request not from user
      @book_request = BookRequest.new
      respond_to do |format|
        if @book_request.save
          format.html { redirect_to libraries_path, notice: 'Book request' }
          format.json { render :show, status: :created, location: @book_request }
        else
          format.html { render :new }
          format.json { render json: @book_request.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /book_requests/1/edit
  def edit
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
    @book_request.destroy
    user = session[:user_type]
    type = params[:request_type]
    respond_to do |format|
      case user
      when ApplicationController::TYPE_STUDENT
        case type
        when BookRequest::IS_BOOKMARK
          format.html { redirect_to book_requests_url(:request_type => BookRequest::IS_BOOKMARK), notice: 'Book request was successfully destroyed.' }
        when BookRequest::IS_HOLD
          format.html { redirect_to book_requests_url(:request_type => BookRequest::IS_HOLD), notice: 'Book request was successfully destroyed.' }
        when BookRequest::IS_SPECIAL
          format.html { redirect_to book_requests_url(:request_type => BookRequest::IS_SPECIAL), notice: 'Book request was successfully destroyed.' }
        end
      else
        format.html { redirect_to book_requests_url, notice: 'Book request was successfully destroyed.' }
        format.json { head :no_content }
      end
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
      #  user = Student.find_by_student_id(params[:student_id])
        @student = Student.find(params[:student_id])
        RequestSuccessfulMailer.with(student: @student).request_successful_email.deliver_now
        format.html { redirect_to book_requests_path, :notice => "Book request accepted" }
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
