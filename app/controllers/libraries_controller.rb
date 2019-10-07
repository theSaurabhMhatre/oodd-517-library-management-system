class LibrariesController < ApplicationController
  before_action :set_library, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  # GET /libraries
  # GET /libraries.json
  def index
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      @libraries = Library.where(:university_id => current_user.university_id)
    when ApplicationController::TYPE_LIBRARIAN
      # TODO: what exactly needs to be done here?
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    when ApplicationController::TYPE_ADMIN
      @libraries = Library.all
    end
  end

  # GET /libraries/1
  # GET /libraries/1.json
  def show
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_ADMIN
      # admin can see any library
    else
      check = Library.check_if_authorised(user_type, current_user.id, params[:id]);
      if(check == false)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    end
  end

  # GET /libraries/new
  def new
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_ADMIN
      @library = Library.new
    else
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    end
  end

  # GET /libraries/1/edit
  def edit
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    when ApplicationController::TYPE_LIBRARIAN
      check = Library.check_if_authorised(user_type, current_user.id, params[:id]);
      if(check == false)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_ADMIN
      # admin can edit any library
    end
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to @library, notice: 'Library was successfully created.' }
        format.json { render :show, status: :created, location: @library }
      else
        format.html { render :new }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /libraries/1
  # PATCH/PUT /libraries/1.json
  def update
    respond_to do |format|
      if @library.update(library_params)
        format.html { redirect_to root_url, notice: 'Library was successfully updated.' }
        format.json { render :show, status: :ok, location: @library }
      else
        format.html { render :edit }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.json
  def destroy
    @library.destroy
    respond_to do |format|
      format.html { redirect_to libraries_url, notice: 'Library was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_library
    @library = Library.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def library_params
    params.require(:library).permit(:name, :location, :max_days, :overdue_fine, :university_id)
  end
end
