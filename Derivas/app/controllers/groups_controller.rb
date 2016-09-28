class GroupsController < ApplicationController
  

  before_action :set_course, :set_activity
  before_action :set_group, only: [:show, :destroy, :update]

  def create
    group = @activity.groups.new(group_params)
    if group.save
      render json: group, status: 201
    else
      render json: group.errors, status: 422
    end
  end

  def index
    render json: @activity.groups
  end

  def show
    render json: @group
  end

  def destroy
    @group.destroy
    render json: @group
  end

  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: 422
    end
  end

  private
    def set_course
      @course = current_user.courses.where(id: params[:course_id]).first
      return head(:not_found) if not @course
    end

    def set_activity
      @activity = @course.activities.where(id: params[:activity_id]).first
      return head(:not_found) if not @activity
    end

    def set_group
      @group = @activity.groups.where(id: params[:id]).first
      return head(:not_found) if not @group
    end

    def group_params
      params.permit(:name_group)
    end
end
