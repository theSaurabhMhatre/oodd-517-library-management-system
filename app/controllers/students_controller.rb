class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :authorize, only: [:index, :show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_ADMIN
      @students = Student.all
    else
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      if(current_user.id != params[:id].to_i)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_LIBRARIAN
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    when ApplicationController::TYPE_ADMIN
      # admin can see any student
    end
  end

  # GET /students/new
  def new
    user_type = session[:user_type]
    case user_type
    when nil
      # request to create a student by a non registered user
      @student = Student.new
      @google_name = params[:name]
      @google_email = params[:email]
    when ApplicationController::TYPE_ADMIN
      # admin can create new students
      @student = Student.new
    else
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    end
  end

  # GET /students/1/edit
  def edit
    user_type = session[:user_type]
    case user_type
    when ApplicationController::TYPE_STUDENT
      if(current_user.id != params[:id].to_i)
        flash[:notice] =  "You are not authorised to perform this action"
        redirect_to root_path
      end
    when ApplicationController::TYPE_LIBRARIAN
      flash[:notice] =  "You are not authorised to perform this action"
      redirect_to root_path
    when ApplicationController::TYPE_ADMIN
      # admin can edit any student
      # TODO: what to do about the book limit when edu_level is updated?
      @edu_level = Student.find(params[:id]).edu_level
      @without_password = 1
    end
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)
    @student.set_book_limit

    respond_to do |format|
      if @student.save
        format.html { redirect_to root_url, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        @student.set_book_limit
        @student.save
        format.html { redirect_to root_url, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    Student.delete(params[:id])
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:email, :name, :password, :edu_level, :book_limit, :university_id)
  end
end
