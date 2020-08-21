class Population < ApplicationRecord
  def self.prepare_excel_records
    records = []
    populations = self.all
    countries = populations.collect(&:country).uniq
    years = populations.collect(&:year).uniq
    countries.each do |country|
      row = []
      years.each do |year|
        pop = Population.where(country: country, year: year)
        population = pop.first
        if population.present?
          unless row.include?(country)
            row << country
            row << population.continent
            row << 'img'
          end
          row << population.population
        else
          unless row.include?(country)
            row << country
            row << ''
            row << 'img'
          end
          row << ''
        end
      end
      records.push(row)
    end
    records
  end

  def self.collect_excel_row_data(population)
    [population.country, population.continent,'img']
  end
end
