#require 'geocoder'

class EbooksController < ApplicationController
  before_action :set_ebook, only: %i[show edit update destroy logs download_pdf buy]
  before_action :log_ebook_view, only: [:show]
  before_action :authenticate_user!
  before_action :authorize_seller_or_admin, only: %i[edit update destroy]
  before_action :authorize_buyer_or_seller, only: %i[buy]

  # GET /ebooks or /ebooks.json
  def index
    @ebooks = Ebook.all
  end

  # GET /ebooks/1 or /ebooks/1.json
  def show
    @ebook = Ebook.find(params[:id])
  end

  # GET /ebooks/new
  def new
    @ebook = Ebook.new
  end

  # GET /ebooks/1/edit
  def edit
  end

  # POST /ebooks or /ebooks.json
  def create
    @ebook = Ebook.new(ebook_params)

    respond_to do |format|
      if @ebook.save
        format.html { redirect_to ebook_url(@ebook), notice: "Ebook was successfully created." }
        format.json { render :show, status: :created, location: @ebook }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ebooks/1 or /ebooks/1.json
  def update
    respond_to do |format|
      if @ebook.update(ebook_params)
        format.html { redirect_to ebook_url(@ebook), notice: "Ebook was successfully updated." }
        format.json { render :show, status: :ok, location: @ebook }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ebooks/1 or /ebooks/1.json
  def destroy
    @ebook.destroy!

    respond_to do |format|
      format.html { redirect_to ebooks_url, notice: "Ebook was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def logs
    @ebook_logs = @ebook.ebook_logs
  end

  def statistics
    @ebooks = Ebook.includes(:ebook_logs).all
  end

  def download_pdf
    if @ebook.pdf.attached?
      log_download_action

      redirect_to rails_blob_path(@ebook.pdf, disposition: "attachment")
    else
      redirect_to @ebook, alert: 'PDF not available.'
    end
  end

  def buy
    if @ebook.status != 'live'
      redirect_to @ebook, alert: 'This ebook is not available for purchase.'
      return
    end

    if @ebook.user.buyer?
      redirect_to @ebook, alert: 'Ebook cannot be bought from a buyer.'
      return
    end

    @ebook.update(user_id: current_user.id)

    log_purchase_action
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ebook
      Rails.logger.debug "Params ID: #{params[:id]}"
      @ebook = Ebook.find_by(id: params[:id])
      if @ebook.nil?
        Rails.logger.debug "Ebook not found with ID: #{params[:id]}"
        render plain: "Ebook not found", status: :not_found
      end
    end

    def log_ebook_view
      # location_data = Geocoder.search(request.remote_ip).first
      # city = location_data&.city || 'Unknown'
      
      city = 'Unknown'

      ebook_log = EbookLog.create(
        ebook: @ebook,
        user: current_user,
        action: :ebook_seen,
        ip_address: request.remote_ip,
        browser: request.user_agent,
        location: city
      )
      if ebook_log.save
        Rails.logger.info "EbookLog saved successfully"
      else
        Rails.logger.error "Failed to save EbookLog: #{ebook_log.errors.full_messages.join(', ')}"
      end
    end

    def log_download_action
      city = 'Unknown'
      last_log = EbookLog.where(
        ebook: @ebook,
        user: current_user,
        action: :draft_viewed
      ).order(created_at: :desc).first
    
      # Prevent logging if the last log was created within the last minute
      if last_log.nil? || last_log.created_at < 1.minute.ago
        city = 'Unknown'
        EbookLog.create!(
          ebook: @ebook,
          user: current_user,
          action: :draft_viewed,
          ip_address: request.remote_ip,
          browser: request.user_agent,
          location: city,
        )
      end
    end


    def log_purchase_action
      # location_data = Geocoder.search(request.remote_ip).first
      # city = location_data&.city || 'Unknown'
      
      city = 'Unknown'

      ebook_log = EbookLog.create(
        ebook: @ebook,
        user: current_user,
        action: :ebook_purchased,
        ip_address: request.remote_ip,
        browser: request.user_agent,
        location: city,
        seller: @ebook.user, # Assuming the user who uploaded the ebook is the seller
        price: @ebook.price,
        fee: calculate_fee(@ebook.price) # Implement this method if you need to calculate a fee
      )
      if ebook_log.save
        Rails.logger.info "EbookLog saved successfully"
      else
        Rails.logger.error "Failed to save EbookLog: #{ebook_log.errors.full_messages.join(', ')}"
      end
    end

    def authorize_seller_or_admin
      if current_user.seller?
        unless @ebook.user == current_user
          redirect_to ebooks_path, alert: 'You are not authorized to perform this action.'
        end
      elsif !current_user.admin?
        redirect_to ebooks_path, alert: 'You are not authorized to perform this action.'
      end
    end
  
    def authorize_buyer_or_seller
      unless current_user.buyer? || current_user.seller?
        redirect_to ebooks_path, alert: 'You are not authorized to perform this action.'
      end
    end

    def calculate_fee(price)
      return 0.1 * price
    end

    # Only allow a list of trusted parameters through.
    def ebook_params
      params.require(:ebook).permit(:title, :description, :price, :status, :user_id, :pdf)
    end
end
