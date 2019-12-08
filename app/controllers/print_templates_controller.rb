class PrintTemplatesController < ApplicationController
  before_action :set_print_template, only: [:show, :edit, :update, :destroy]
  layout "setting"

  # GET /print_templates
  # GET /print_templates.json
  def index
    type = params[:type].present? ? params[:type] : "invoice"
    @print_templates = PrintTemplate.by_store_and_type(current_store.id, type)
    p @print_templates
  end

  # GET /print_templates/1
  # GET /print_templates/1.json
  def show
  end

  # GET /print_templates/new
  def new
    @print_template = PrintTemplate.new
  end

  # GET /print_templates/1/edit
  def edit
  end

  # POST /print_templates
  # POST /print_templates.json
  def create
    @print_template = PrintTemplate.new(print_template_params)
    @print_template.user = current_user
    @print_template.store = current_store

    respond_to do |format|
      if @print_template.save
        format.html { redirect_to print_templates_path(type: @print_template.template_type), notice: 'Print template was successfully created.' }
        format.json { render :show, status: :created, location: @print_template }
      else
        format.html { render :new }
        format.json { render json: @print_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /print_templates/1
  # PATCH/PUT /print_templates/1.json
  def update
    respond_to do |format|
      if @print_template.update(print_template_params)
        format.html { redirect_to print_templates_path(type: @print_template.template_type), notice: 'Print template was successfully updated.' }
        format.json { render :show, status: :ok, location: @print_template }
      else
        format.html { render :edit }
        format.json { render json: @print_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /print_templates/1
  # DELETE /print_templates/1.json
  def destroy
    @print_template.destroy
    respond_to do |format|
      format.html { redirect_to print_templates_url, notice: 'Print template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_print_template
      @print_template = PrintTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def print_template_params
      params.require(:print_template).permit(:name, :template_type, :size, :template)
    end
end
