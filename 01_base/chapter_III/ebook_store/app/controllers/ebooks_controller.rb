require 'geocoder'

class EbooksController < ApplicationController
  before_action :set_ebook, only: %i[show edit update destroy logs download_pdf buy]
  before_action :log_ebook_view, only: [:show]
  #before_action :authenticate_user!
  before_action :authorize_seller_or_admin, only: %i[edit update destroy]
  before_action :authorize_buyer_or_seller, only: %i[buy]

  # GET /ebooks or /ebooks.json
  def index
    if params[:tags].present?
      tag_ids = params[:tags].reject(&:blank?)
      text_tags = Tag.where(id: tag_ids, tag_type: 'text')
      Rails.logger.info "### text_tags.count: #{text_tags.count}" 
      user_tags = Tag.where(id: tag_ids, tag_type: 'user')
      Rails.logger.info "### user_tags.count: #{user_tags.count}" 
      
      if text_tags.exists? && user_tags.exists?
        text_tag_ids = text_tags.pluck(:id)
        user_tag_ids = user_tags.pluck(:id)
  
        @ebooks = Ebook.joins(:taggings).where(
          'ebooks.id IN (
            SELECT ebook_id FROM taggings WHERE tag_id IN (:text_tag_ids)
          ) AND ebooks.id IN (
            SELECT ebook_id FROM taggings WHERE tag_id IN (:user_tag_ids)
          )',
          text_tag_ids: text_tag_ids,
          user_tag_ids: user_tag_ids
        ).distinct
      elsif text_tags.exists?
        @ebooks = Ebook.joins(:tags).where(tags: { id: text_tags.pluck(:id) }).distinct
      elsif user_tags.exists?
        @ebooks = Ebook.joins(:tags).where(tags: { id: user_tags.pluck(:id) }).distinct
      else
        @ebooks = Ebook.none
      end

    else
      @ebooks = Ebook.all
    end
  end
  

  # GET /ebooks/1 or /ebooks/1.json
  def show
    @ebook = Ebook.find(params[:id])
  end

  # GET /ebooks/new
  def new
    @ebook = Ebook.new
    @tags = Tag.all
  end

  # GET /ebooks/1/edit
  def edit
    @tags = Tag.all
  end

  # POST /ebooks or /ebooks.json
  def create
    @ebook = Ebook.new(ebook_params)

    respond_to do |format|
      if @ebook.save
        manage_tags
        #UserMailer.with(ebook: @ebook, user: current_user).welcome_email.deliver_now
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
        manage_tags
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

    selling_user = User.find(@ebook.user_id)
    fee = calculate_fee(@ebook.price)
    log_purchase_action
    @ebook.update(user_id: current_user.id)
    UserMailer.with(ebook: @ebook, user: selling_user, fee: fee).ebook_bought_email.deliver_now
    UserMailer.with(ebook: @ebook, user: current_user).ebook_statistics_email.deliver_now
    redirect_to @ebook
  end

  private

  def manage_tags
    # Clear existing tags
    @ebook.tags.destroy_all
  
    # Add new tags
    tags = params[:ebook][:tag_ids].reject(&:blank?)
    tags.each do |tag_id|
      @ebook.tags << Tag.find(tag_id)
    end
  end

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
    location_data = Geocoder.search(request.remote_ip).first
    city = location_data&.city || 'Unknown'

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
    location_data = Geocoder.search(request.remote_ip).first
    city = location_data&.city || 'Unknown'
    last_log = EbookLog.where(
      ebook: @ebook,
      user: current_user,
      action: :draft_viewed
    ).order(created_at: :desc).first
  
    # Prevent logging if the last log was created within the last minute
    if last_log.nil? || last_log.created_at < 1.minute.ago
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
    location_data = Geocoder.search(request.remote_ip).first
    city = location_data&.city || 'Unknown'

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
    params.require(:ebook).permit(:title, :description, :price, :status, :user_id, :pdf, :cover)
  end
end
