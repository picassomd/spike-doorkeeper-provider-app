# frozen_string_literal: true

Doorkeeper::OpenidConnect.configure do
  issuer do |resource_owner, application|
    puts resource_owner.inspect
    puts application.inspect

    'http://localhost:3000'
  end

  signing_key File.read(File.join('keys', 'private_key.pem'))

  signing_algorithm :rs256

  subject_types_supported [:public]

  resource_owner_from_access_token do |access_token|
    # Example implementation:
    User.find_by(id: access_token.resource_owner_id)
  end

  auth_time_from_resource_owner do |resource_owner|
    # Example implementation:
    # resource_owner.current_sign_in_at
  end

  reauthenticate_resource_owner do |resource_owner, return_to|
    # Example implementation:
    # store_location_for resource_owner, return_to
    # sign_out resource_owner
    # redirect_to new_user_session_url
  end

  # Depending on your configuration, a DoubleRenderError could be raised
  # if render/redirect_to is called at some point before this callback is executed.
  # To avoid the DoubleRenderError, you could add these two lines at the beginning
  #  of this callback: (Reference: https://github.com/rails/rails/issues/25106)
  #   self.response_body = nil
  #   @_response_body = nil
  select_account_for_resource_owner do |resource_owner, return_to|
    # Example implementation:
    # store_location_for resource_owner, return_to
    # redirect_to account_select_url
  end

  subject do |resource_owner, application|
    # Example implementation:
    resource_owner.id

    # or if you need pairwise subject identifier, implement like below:
    # Digest::SHA256.hexdigest("#{resource_owner.id}#{URI.parse(application.redirect_uri).host}#{'your_secret_salt'}")
  end

  # Protocol to use when generating URIs for the discovery endpoint,
  # for example if you also use HTTPS in development
  # protocol do
  #   :https
  # end

  # Expiration time on or after which the ID Token MUST NOT be accepted for processing. (default 120 seconds).
  # expiration 600

  # Example claims:
  claims do
    claim :email do |resource_owner|
      resource_owner.email
    end

    # claim :full_name do |resource_owner|
    #   "#{resource_owner.first_name} #{resource_owner.last_name}"
    # end

    # claim :preferred_username, scope: :openid do |resource_owner, scopes, access_token|
    #   # Pass the resource_owner's preferred_username if the application has
    #   # `profile` scope access. Otherwise, provide a more generic alternative.
    #   scopes.exists?(:profile) ? resource_owner.preferred_username : "summer-sun-9449"
    # end
    #
    # claim :groups, response: [:id_token, :user_info] do |resource_owner|
    #   resource_owner.groups
    # end
  end
end
