class ActivitiesController < ApplicationController
  
  before_action :set_course
  before_action :set_activity, only: [:show, :destroy, :update]
  
  def create
    activity = @course.activities.new(activity_params)
    if activity.save
      render json: activity, status: 201
    else
      render json: activity.errors, status: 422
    end
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
