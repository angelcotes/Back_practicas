class GroupsController < ApplicationController
  
  before_action :set_group, only: [:show, :destroy, :update]

  def create
    group = Group.new(group_params)
    if group.save
      render json: group, status: 201
    else
      render json: group.errors, status: 422
    end
  end

  def index
    render json: Group.all
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
    def set_group
      @group = Group.where(id: params[:id]).first
      return head(404) if not @group
    end

    def group_params
      params.permit(:name_group, :activity_id)
    end
end
