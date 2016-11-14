class StudentsController < ApplicationController
  before_action :set_course
  before_action :set_student, only: [:update, :destroy]

  def index
    render json: @course.students
  end

  def create
    error_data = Hash.new
    p params[:data]
    params[:data].each do |email|
      user = User.where(email: email).first
      if user
        student = @course.students.new(user_id: user.id)
        if !student.save
          error_data.push(email)
        end 
      end
    end
    if error_data
      render json: error_data, status: 422
    else
      render json: student, status: 201
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
    members = Member.where(user_id: @student[:user_id])
    members.each do |member|
      Member.destroy(member[:id])
    end
    @student.destroy
  end

  private
  def set_course
    @course = current_user.courses.where(id: params[:course_id]).first
    return head(:not_found) unless @course
  end

  def set_student
    @student = @course.students.where(id: params[:id]).first
    return head(:not_found) unless @student
  end

  def student_params
    params.permit(:course_id)
  end
end
