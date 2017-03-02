class DatatableClass
  delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(data_hash)
    @view = data_hash[:view_context]
    @sort_column = data_hash[:sort_column]
    @model = data_hash[:model]
    @search_query = data_hash[:search_query]
    if data_hash[:join_table].present?
      @join_table = data_hash[:join_table]
    end

  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: @model.count,
        iTotalDisplayRecords: model_data.total_entries,
        aaData: data
    }
  end

  private

  def data
    case @model.to_s
      when 'Payroll'
        model_data.map do |payroll|
          [
              payroll.date,
              "#{payroll.worker.first_name} #{payroll.worker.last_name} #{payroll.worker.middle_name}"
          ]
        end
      when 'OrderManufacturing'
        model_data.map do |model_data_i|
          [
              model_data_i.date,
              model_data_i.number,
              model_data_i.counterparty.name,
              model_data_i.invoice,
          ]

        end
    end

  end

  def model_data
    @model_data ||= fetch_model_data
  end

  def fetch_model_data
    model_data_var = @model.order("#{sort_column} #{sort_direction}")
    model_data_var = model_data_var.page(page).per_page(per_page)
    if params[:sSearch].present?
      if @join_table.present?
        model_data_var = model_data_var.join(@join_table)
                             .where(@search_query, join_table_var: "SELECT #{@join_table}.id FROM #{@join_table}.name like :search", search: "%#{params[:sSearch]}%")
      else
        model_data_var = model_data_var.where(@search_query, search: "%#{params[:sSearch]}%")
      end


    end
    model_data_var
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = @sort_column
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
