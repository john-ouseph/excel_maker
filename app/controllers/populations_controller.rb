class PopulationsController < ApplicationController
  before_action :set_population, only: [:show, :edit, :update, :destroy]
  require 'csv'

  # GET /populations
  # GET /populations.json
  def index
    @populations = Population.all
  end

  # GET /populations/1
  # GET /populations/1.json
  def show
  end

  # GET /populations/new
  def new
    @population = Population.new
  end

  # GET /populations/1/edit
  def edit
  end

  # POST /populations
  # POST /populations.json
  def create
    @population = Population.new(population_params)

    respond_to do |format|
      if @population.save
        format.html { redirect_to @population, notice: 'Population was successfully created.' }
        format.json { render :show, status: :created, location: @population }
      else
        format.html { render :new }
        format.json { render json: @population.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /populations/1
  # PATCH/PUT /populations/1.json
  def update
    respond_to do |format|
      if @population.update(population_params)
        format.html { redirect_to @population, notice: 'Population was successfully updated.' }
        format.json { render :show, status: :ok, location: @population }
      else
        format.html { render :edit }
        format.json { render json: @population.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /populations/1
  # DELETE /populations/1.json
  def destroy
    @population.destroy
    respond_to do |format|
      format.html { redirect_to populations_url, notice: 'Population was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
  end

  def import_file
    file_name = params[:file]
    file_path = "/home/user/Documents/#{file_name}"
    CSV.foreach(file_path, headers: true, skip_blanks: true, encoding: 'iso-8859-1:utf-8') do |record|
        next if record['country'].blank?

        @year = record['year'] if record['year'].present?
        pop = Population.new
        pop.update(country: record['country'],
                   population: record['population'],
                   year: @year,
                   rank: record['rank'])
    end
    redirect_to action: 'index'
  end

  def delete_all
    Population.delete_all
    redirect_to action: 'index'
  end

  def export
  # Fill workbook here or leave as is to download empty
      string_obj = StringIO.new
      workbook = WriteXLSX.new(string_obj)
      sheet = workbook.add_worksheet('Book1')
      format = workbook.add_format
      format.set_bold
      format.set_color('black')
      records = Population.prepare_excel_records
      write_excel_file(records, format, sheet)
      workbook.close
      send_data string_obj.string, type: 'application/xlsx', filename: 'pop.xlsx'
end

  private
    def write_excel_file(records, format, sheet)
      binding.pry
      rows = records
      if rows.present?
        col = row = 0
        sheet.write(row, col, excel_header, format)
        rows.each_with_index do |rec, index|
          row = index + 1
          sheet.write(row, col, rec)
        end
      else
        sheet.write(0, 0, 'No files found', format)
      end
    end

    def excel_header
      ['Country', 'Indicator', 'Image'].concat(Population.all.collect(&:year).uniq)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_population
      @population = Population.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def population_params
      params.require(:population).permit(:year, :country, :continent, :population, :rank)
    end
end
