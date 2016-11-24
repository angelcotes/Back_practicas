class MembersController < ApplicationController
  def create
  end

  def update
  end

  def destroy
  end

  def index
  end

  private
    def member_params
      params.permit(:type_document, :address, :member_id, :group_id)
    end
end
