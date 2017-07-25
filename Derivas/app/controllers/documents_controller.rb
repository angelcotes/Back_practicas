class DocumentsController < ApplicationController

	def create
		document = Document.new(params)
	    if document.save
	      render json: document, status: 201
	    else
	      render json: document.errors, status: 422
	    end
	end

	def show
	end

  	def destroy
	end

	def index
	end

  def download
    doc = Document.find(params[:id])
    send_file "#{Rails.root}#{doc.file_path}", disposition: 'inline'
  end

  private
    def document_params
      params.permit(:type_document, :address, :member_id, :group_id)
    end
end
