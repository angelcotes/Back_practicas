class ActivitiesController < ApplicationController
  
  before_action :set_course
  before_action :set_activity, only: [:show, :destroy, :update]
  
  def create
    not_found = []
    errors_data = []
    successful_data = []
    courses_nrc = params[:nrc].split(",")
    courses_nrc.each do |course_nrc|
      data_course = current_user.courses.where(nrc: course_nrc).first  
      if data_course
        params[:course_id] = data_course.id
        activity = data_course.activities.new(activity_params)
        if activity.save
          successful_data.push(activity)
        else
          errors_data.push(activity)
        end
      else
        not_found.push({course_id: course_nrc})
      end
    end
    response = {:error_data => errors_data,
                :successful_data => successful_data,
                :not_fount => not_found}
    p response
    render json: response, status: 200 
  end

  def index
    activities = []
    @course.activities.each do |activity|
      activity = {
        :id => activity.id,
        :name_activity => activity.name_activity,
        :range => activity.range, 
        :latitude => activity.latitude, 
        :longitude => activity.longitude, 
        :start_date => activity.start_date, 
        :finish_date => activity.finish_date, 
        :duration => activity.duration, 
        :course_id => activity.course_id,
        :course_nrc => @course.nrc
      }
      activities.push(activity)
    end
    render json: activities
  end

  def show
    render json: @activity
  end

  def destroy
    curso = Course.find(@activity[:course_id])
    students = Student.where(course_id: curso[:id])
    students.each do |student|
      members = Member.where(user_id: student[:user_id])
      members.each do |member|
        Member.destroy(member[:id])
      end
    end
    @activity.destroy
    render json: @activity
  end

  def update
    if @activity.update(activity_params)
      render json: @activity
    else
      render json: @activity.errors, status: 422
    end
  end

  private
    def set_activity
      @activity = @course.activities.where(id: params[:id]).first
      return head(:not_fount) if not @activity
    end

    def activity_params
      params.permit(:name_activity, :range, :latitude, :longitude, :start_date, :finish_date, :duration)
    end

    def set_course
      @course = current_user.courses.where(nrc: params[:course_id]).first
      return head(:not_fount) if not @course
    end
end
