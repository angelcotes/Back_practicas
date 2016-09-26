class ActivitiesController < ApplicationController
  
  before_action :set_activity, only: [:show, :destroy, :update]

  def create
    activity = Activity.new(activity_params)
    if activity.save
      render json: activity, status: 201
    else
      render json: activity.errors, status: 422
    end
  end

  def index
    render json: Activity.all
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
      @activity = Activity.where(id: params[:id]).first
      return head(:not_fount) if not @activity
    end

    def activity_params
      params.permit(:name_activity, :range, :latitude, :longitude, :start_date, :finish_date, :duration, :course_id)
    end
end
