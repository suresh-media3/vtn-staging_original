ActiveAdmin.register User do
menu :if => proc{ can?(:manage, User) }     

  action_item :only => :show do
    link_to('Approve', update_appraiser_status_path(:user => user, :status => EAUserStatusConfirmed)) if user.role == "appraiser" && user.status == EAUserStatusPending
  end  
  action_item :only => :show do
    link_to('Reject', update_appraiser_status_path(:user => user, :status => EAUserStatusRejected)) if user.role == "appraiser" && user.status == EAUserStatusPending
  end  
 
 
	index do
		column :id
		column :email
		column :name
		column :role
		column :current_sign_in_at
		column :last_sign_in_at
		column :sign_in_count
		default_actions
	end

  filter :id
  filter :name
  filter :role, :as => :select, :collection => User.roles

	form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :email
      f.input :role, :as => :select, :collection => User.roles
    end
    f.buttons
  end

  after_create { |admin| admin.send_reset_password_instructions }
  def password_required?
    new_record? ? false : super
  end


  controller do
  	load_and_authorize_resource :except => :index
  	def scoped_collection
  		end_of_association_chain.accessible_by(current_ability)
  	end
  	rescue_from CanCan::AccessDenied do |exception|
  		redirect_to admin_dashboard_path, :alert => exception.message
  	end
  end

  show :title => :name do
    attributes_table do
      row("Name") {user.name}
      row("Email") {user.email}
      row("Created") {user.created_at}
      row("Role") {user.role}
      row("Status") {user.status}
    end

    # panel "Avatar" do
    #   render "appraiser_avatar", :locals => {:user => user}
    # end

    panel "Additional Information" do
      render "appraiser_info", :locals => {:appraiser_info => user.appraiser_info}
    end

    panel "Trade References" do
      render "trade_references", :locals => {:user => user}      
    end
  end
end
