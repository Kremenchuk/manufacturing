class DatatableClass
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end
  # = payroll.date

  # = "#{payroll.worker.first_name} #{payroll.worker.last_name} #{payroll.worker.middle_name}"
  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Payroll.count,
        iTotalDisplayRecords: payrolls.total_entries,
        aaData: data
    }
  end

  private

  def data
    payrolls.map do |payroll|
      [
          link_to(payroll.date, payroll),
          h("#{payroll.worker.first_name} #{payroll.worker.last_name} #{payroll.worker.middle_name}"),
      ]
    end
  end

  def payrolls
    @payrolls ||= fetch_payrolls
  end

  def fetch_payrolls
    payrolls = Payroll.order("#{sort_column} #{sort_direction}")
    payrolls = payrolls.page(page).per_page(per_page)
    if params[:sSearch].present?
      payrolls = payrolls.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    payrolls
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[date worker]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
