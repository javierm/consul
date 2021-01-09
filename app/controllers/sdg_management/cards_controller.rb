class SDGManagement::CardsController < SDGManagement::BaseController
  include Admin::Widget::CardsActions

  load_and_authorize_resource :page, class: "SDG::Phase", id_param: "sdg_phase_id"
  load_and_authorize_resource :card, through: :page, class: "Widget::Card"

  private

    def index_path
      sdg_management_homepage_path
    end
end
