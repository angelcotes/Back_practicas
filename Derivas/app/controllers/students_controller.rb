class StudentsController < ApplicationController
  before_action :set_course
  before_action :set_student, only: [:update, :destroy]

  def index
    render json: @course.students
  end

  def create
    user = User.where(email: params[:email]).first
    return head(422) unless user 
    student = @course.students.new(user_id: user.id)
    if student.save
      render json: student, status: 201
    else
      render json: student.errors, status: 422
    end
  end

  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: 422
    end
  end

  def destroy
    @student.destroy
  end

  private
  def set_course
    @course = current_user.courses.where(id: params[:course_id]).first
    return head(:not_found) unless @course
  end

  def set_student
    @student = @course.students.where(id: params[:user_id]).first
    return head(:not_found) unless @student
  end

  def student_params
    params.permit(:course_id)
  end
end
