require_dependency Rails.root.join('app', 'controllers', 'debates_controller').to_s

class DebatesController

  private
    def debate_params
      params.require(:debate).permit(:title, :description, :tag_list, :terms_of_service, :area)
    end
end
