# Серверна обробка даних для datatable таблиць

class DatatableClass
  delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(data_hash)
    @view = data_hash[:view_context]
    @sort_column = data_hash[:sort_column]
    @model = data_hash[:model]
    @search_query = data_hash[:search_query]
    @modal_query = data_hash[:modal_query] if data_hash[:modal_query].present?
    @check_element = data_hash[:check_element] if data_hash[:check_element].present?
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: @model.count,
        iTotalDisplayRecords: model_data.total_entries,
        aaData: data
    }
  end

  def with_out_model(data = [])
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: data.count,
        iTotalDisplayRecords: data.count,
        aaData: MappingModelData.new(data).send(@model.to_s.tableize.singularize)
    }
  end

  private

  def data
    MappingModelData.new(model_data, (@modal_query if @modal_query.present?), (@check_element if @check_element.present?)).send(@model.to_s.tableize.singularize)
  end

  def model_data
    @model_data ||= fetch_model_data
  end

  def fetch_model_data
    model_data = @model.order("#{sort_column} #{sort_direction}")
    model_data = model_data.page(page).per_page(per_page)
    if params[:sSearch].present?
      model_data = model_data.where(@search_query, search: "%#{params[:sSearch].mb_chars.upcase.to_s}%")
    elsif params[:search].present?
      model_data = model_data.where(@search_query, search: "%#{params[:search][:value].mb_chars.upcase.to_s}%")
    end
    model_data
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = @sort_column
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
