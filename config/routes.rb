Rails.application.routes.draw do
  resources :item_groups
  devise_for :users
  root 'home#index'

  # users
    resources :users

  #order_manufacturings
    resources :order_manufacturings
    get 'o_m_details_datatable' => 'order_manufacturings#o_m_details_datatable'
    get 'o_m_details_pre_print_datatable/:id' => 'order_manufacturings#o_m_details_pre_print_datatable', as: 'o_m_details_pre_print_datatable'

    get 'o_m_automatic_print/:id' => 'order_manufacturings#o_m_automatic_print', as: 'o_m_automatic_print'

    get 'copy_o_m/:id' => 'order_manufacturings#copy_o_m', as: 'copy_o_m'
    get 'add_o_m_detail' => 'order_manufacturings#add_o_m_detail'
    get 'add_counterparty' => 'order_manufacturings#add_counterparty'
    get 'o_m_counterparty_datatable' => 'order_manufacturings#o_m_counterparty_datatable'
    get 'o_m_used_materials/:id' => 'order_manufacturings#o_m_used_materials', as: 'o_m_used_materials'
    get 'o_m_used_jobs/:id' => 'order_manufacturings#o_m_used_jobs', as: 'o_m_used_jobs'
    put 'o_m_change_status/:id' => 'order_manufacturings#o_m_change_status', as: 'o_m_change_status'
    put 'remove_file_from_o_m/:id' => 'order_manufacturings#remove_file_from_o_m', as: 'remove_file_from_o_m'

    # get 'o_m_hand_print/:id' => 'order_manufacturings#o_m_hand_print', as: 'o_m_hand_print'
    # get 'o_m_pre_print/:id' => 'order_manufacturings#o_m_pre_print', as: 'o_m_pre_print'
  #---order_manufacturings---

  #payrolls
    resources :payrolls
  #---payrolls---

  #items
    resources :items
    get 'add_item_detail' => 'items#add_item_detail'
    get 'add_item_group' => 'items#add_item_group'
    # для заповнення модального вікна при виборі виробів для details
    get 'item_details_datatable' => 'items#item_details_datatable'
    get 'copy_item/:id' => 'items#copy_item', as: 'copy_item'
    get 'add_item_group' => 'items#add_item_group'
    put 'remove_file_from_item/:id' => 'items#remove_file_from_item', as: 'remove_file_from_item'
    get 'item_material_datatable' => 'items#item_material_datatable'
  #---items---

  #item_groups
    resources :item_groups
    get 'item_item_group_datatable' => 'items#item_item_group_datatable'
  # ---item_groups---

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

  #role
  resources :roles
  #---role---

  #role
  resources :item_groups
  #---role---

  # purchese_invoice
    resources :purchase_invoices
    get 'add_counterparty_p_i' => 'purchase_invoices#add_counterparty_p_i'
    get 'add_p_i_detail' => 'purchase_invoices#add_p_i_detail'
    get 'p_i_details_datatable' => 'purchase_invoices#p_i_details_datatable'
    get 'p_i_counterparty_datatable' => 'purchase_invoices#p_i_counterparty_datatable'
    get 'p_i_material_details_datatable' => 'purchase_invoices#p_i_material_details_datatable'
    get 'add_p_i_detail' => 'purchase_invoices#add_p_i_detail'
    put 'material_to_warehouse/:id' => 'purchase_invoices#material_to_warehouse', as: 'material_to_warehouse'
    put 'material_from_warehouse/:id' => 'purchase_invoices#material_from_warehouse', as: 'material_from_warehouse'
  #---purchese_invoice---


  # get 'material_details_datatable' => 'purchase_invoices#material_details_datatable'
  # #semi_finisheds
  #   resources :semi_finisheds
  #   get 'copy_semi_finished/:id' => 'copy_semi_finisheds#copy_semi_finished', as: 'copy_semi_finished'
  #   put 'add_semi_finished_details' => 'semi_finisheds#add_semi_finished_details'
  # # #---semi_finisheds---
end
