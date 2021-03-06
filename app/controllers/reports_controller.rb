class ReportsController < ApplicationController

  before_action :authenticate_user!, except: [:show]
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  before_filter :is_admin?, except: [:show]
  
  def is_admin?
    if current_user.admin?
      true
    else
      redirect_to root_url
    end
  end

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.page(params[:page]).order('created_at ASC')
      respond_to do |format|
        format.html
        format.csv { send_data @reports.to_csv }
      end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@report)
        send_data pdf.render, filename: "report#{@report.created_at.strftime("%d/%m/%Y")}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end

  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:reportnumber, :reference, :species, :variety, :weight, :dimension, :shapecut, :colour, :item, :transparency, :requesof, :comments, :image)
    end
end
