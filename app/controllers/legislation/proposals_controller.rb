class Legislation::ProposalsController < Legislation::BaseController
  include CommentableActions
  include FlagActions

  before_action :parse_tag_filter, only: :index
  before_action :load_categories, only: [:index, :new, :create, :edit, :map, :summary]
  before_action :load_geozones, only: [:edit, :map, :summary]

  before_action :authenticate_user!, except: [:index, :show, :map, :summary]
  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :proposal, class: "Legislation::Proposal", through: :process

  invisible_captcha only: [:create, :update], honeypot: :subtitle

  has_orders %w{confidence_score created_at}, only: :index
  has_orders %w{most_voted newest oldest}, only: :show

  helper_method :resource_model, :resource_name
  respond_to :html, :js

  def show
    super
    legislation_proposal_votes(@process.proposals)
    @document = Document.new(documentable: @proposal)

    @mensajeAlert=MemberType.textoParticipanteTipo2WithPrefix(current_user, @process.member_type_ids, t("legislation.processes.proposals.member_type_denied"))

    if request.path != legislation_process_proposal_path(params[:process_id], @proposal)
      redirect_to legislation_process_proposal_path(params[:process_id], @proposal),
                  status: :moved_permanently
    end
  end

  def create

    @mensajeAlert=MemberType.textoParticipanteTipo2WithPrefix(current_user, @process.member_type_ids, t("legislation.processes.proposals.member_type_denied_creating"))

    if @mensajeAlert.nil?
      @proposal = Legislation::Proposal.new(proposal_params.merge(author: current_user))

      if @proposal.save
        redirect_to legislation_process_proposal_path(params[:process_id], @proposal), notice: I18n.t('flash.actions.create.proposal')
      else
        render :new
      end
    else
      flash.now[:alert]=(@mensajeAlert)
      render :new
    end
  end

  def index_customization
    load_successful_proposals
    load_featured unless @proposal_successful_exists
  end

  def vote
    if MemberType.can_vote_proposals?(current_user, @process.member_type_ids)
       @proposal.register_vote(current_user, params[:value])
       audit_info("Votacion de propuesta: { \"value\": \"#{params[:value]}\", \"Sexo\": \"#{current_user.gender}\", \"Edad\": \"#{current_user.age}\", \"CodigoPostal\": \"#{current_user.postal_code}\", \"Proceso\": \"#{@process.id}\", \"Propuesta\": \"#{@proposal.id}\" }")
    else
      audit_error("El usuario con id: #{current_user.id}, document_type: #{current_user.document_type} y document_number: #{current_user.document_number} ha tratado de votar sin permiso.")
    end
    legislation_proposal_votes(@proposal)
  end

  private

    def proposal_params
      params.require(:legislation_proposal).permit(:legislation_process_id, :title,
                    :question, :summary, :description, :video_url, :tag_list,
                    :terms_of_service, :geozone_id,
                    image_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy],
                    documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id])
    end

    def resource_model
      Legislation::Proposal
    end

    def resource_name
      'proposal'
    end

    def load_successful_proposals
      @proposal_successful_exists = Legislation::Proposal.successful.exists?
    end

end
