class LibrariansController < ApplicationController
  before_action :set_librarian, only: [:show, :edit, :update, :destroy]
  before_action :authorize, only: [:index, :show, :edit, :update, :destroy]

  # GET /librarians
  # GET /librarians.json
  def index
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_ADMIN
      @librarians = Librarian.all
    else
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    end
  end

  # GET /librarians/1
  # GET /librarians/1.json
  def show
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    when ApplicationController::TYPE_LIBRARIAN
      if(current_user.id != params[:id].to_i)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_ADMIN
      # admin can see any librarian
    end
  end

  # GET /librarians/new
  def new
    user_type = session[:user_type]
    case user_type
    when nil
      # request to create a librarian by a non registered user
      @librarian = Librarian.new
    when ApplicationController::TYPE_ADMIN
      @librarian = Librarian.new
      @librarian.is_approved = 0
    else
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    end
  end

  # GET /librarians/1/edit
  def edit
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_ADMIN
      @without_password = 1
      @edit_librarian_errors = params[:edit_librarian_errors]
      @library_id = Librarian.find(params[:id]).library_id
    when ApplicationController::TYPE_LIBRARIAN
      if(current_user.id != params[:id].to_i)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
      @library_id = Librarian.find(params[:id]).library_id
    when ApplicationController::TYPE_STUDENT
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    end
  end

  # POST /librarians
  # POST /librarians.json
  def create
    @librarian = Librarian.new(librarian_params)
    @librarian[:is_approved] = 0
    respond_to do |format|
      if @librarian.save
        format.html { redirect_to @librarian, notice: 'Librarian was successfully created.' }
        format.json { render :show, status: :created, location: @librarian }
      else
        format.html { render :new }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /librarians/1
  # PATCH/PUT /librarians/1.json
  def update
    respond_to do |format|
      if @librarian.update(librarian_params)
        format.html { redirect_to root_url, notice: 'Librarian was successfully updated.' }
        format.json { render :show, status: :ok, location: @librarian }
      else
        format.html { redirect_to edit_librarian_path(@librarian,:edit_librarian_errors => @librarian.errors.full_messages) }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    @librarian = Librarian.find(params[:id])
    @librarian.update_column(:is_approved, 1)
    redirect_to librarians_url
  end

  # DELETE /librarians/1
  # DELETE /librarians/1.json
  def destroy
    @librarian.destroy
    respond_to do |format|
      format.html { redirect_to librarians_url, notice: 'Librarian was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_librarian
    @librarian = Librarian.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def librarian_params
    params.require(:librarian).permit(:email, :name, :password, :password_confirmation, :is_approved, :university_id, :library_id)
  end
end
