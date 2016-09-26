class CoursesController < ApplicationController
  
  before_action :set_course, only: [:show, :destroy, :update]

  def create
    course = Course.new(course_params)
    if course.save
      render json: course, status: 201  
    else
      render json: course.errors, status: 422
    end
  end

  def index
    render json: Course.all
  end

  def show
    render json: @course
  end

  def destroy
    @course.destroy
    render json: @course
  end

  def update
    if @course.update(course_params)
      render json: @course
    else
      render json: @course.errors, status: 422
    end
  end

  private
    def set_course
      @course = Course.where(id: params[:id]).first
      return head(:not_found) if not @course 
    end

    def course_params
      params.permit(:name, :period, :user_id)
    end
end
