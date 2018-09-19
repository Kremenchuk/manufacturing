Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  #order_manufacturings
    resources :order_manufacturings
    get 'o_m_details_datatable' => 'order_manufacturings#o_m_details_datatable'
    get 'o_m_details_pre_print_datatable/:id' => 'order_manufacturings#o_m_details_pre_print_datatable', as: 'o_m_details_pre_print_datatable'

    get 'o_m_details_print/:id' => 'order_manufacturings#o_m_details_print', as: 'o_m_details_print'

    get 'copy_o_m/:id' => 'order_manufacturings#copy_o_m', as: 'copy_o_m'
    get 'add_o_m_detail' => 'order_manufacturings#add_o_m_detail'
    get 'add_counterparty' => 'order_manufacturings#add_counterparty'
    get 'o_m_counterparty_datatable' => 'order_manufacturings#o_m_counterparty_datatable'
    get 'o_m_print/:id' => 'order_manufacturings#o_m_print', as: 'o_m_print'
    # get 'o_m_pre_print/:id' => 'order_manufacturings#o_m_pre_print', as: 'o_m_pre_print'
  #---order_manufacturings---

  #payrolls
    resources :payrolls
  #---payrolls---

  #items
    resources :items
    get 'add_item_detail' => 'items#add_item_detail'
    # для заповнення модального вікна при виборі виробів для details
    get 'item_details_datatable' => 'items#item_details_datatable'
    get 'copy_item/:id' => 'items#copy_item', as: 'copy_item'

  #---items---

  #jobs
    resources :jobs
    # для заповнення модального вікна при виборі робіт для details
    get 'job_details_datatable' => 'jobs#job_details_datatable'
    get 'copy_job/:id' => 'jobs#copy_job', as: 'copy_job'
    get 'add_job_detail' => 'jobs#add_job_detail'
  #---jobs---

  #workers
    resources :workers
  #---workers---

  #counterparties
    resources :counterparties
  #---counterparties---

  #materials
    resources :materials
    get 'copy_material/:id' => 'materials#copy_material', as: 'copy_material'
    get 'add_material_detail' => 'materials#add_material_detail'
    get 'material_details_datatable' => 'materials#material_details_datatable'
  #---materials---

  # #semi_finisheds
    resources :semi_finisheds
    get 'copy_semi_finished/:id' => 'copy_semi_finisheds#copy_semi_finished', as: 'copy_semi_finished'
    put 'add_semi_finished_details' => 'semi_finisheds#add_semi_finished_details'
  # #---semi_finisheds---
end
