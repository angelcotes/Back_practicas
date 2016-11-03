class ActivitiesController < ApplicationController
  
  before_action :set_course
  before_action :set_activity, only: [:show, :destroy, :update]
  
  def create
    not_found = []
    errors_data = []
    successful_data = []
    courses_id = params[:courses_id].split(",")
    courses_id.each do |course_id|
      data_course = current_user.courses.where(id: course_id).first  
      if data_course
        params[:course_id] = data_course.id
        activity = data_course.activities.new(activity_params)
        if activity.save
          successful_data.push(activity)
        else
          errors_data.push(activity)
        end
      else
        not_found.push({course_id: course_id})
      end
    end
    response = {:error_data => errors_data,
                :successful_data => successful_data,
                :not_fount => not_found}
    p response
    render json: response, status: 200 
  end

  def index
    render json: @course.activities
  end

  def show
    render json: @activity
  end

  def destroy
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
      params.permit(:name_activity, :range, :latitude, :longitude, :start_date, :finish_date, :duration, :course_id)
    end

    def set_course
      @course = current_user.courses.where(id: params[:course_id]).first
      return head(:not_fount) if not @course
    end
end
