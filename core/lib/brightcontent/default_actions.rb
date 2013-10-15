module Brightcontent
  module DefaultActions
    def show
      redirect_to action: :edit
    end

    %w{create update destroy}.each do |action|
      define_method action do |*args, &block|
        if block
          super *args, &block
        else
          super() do |format|
            format.json
            format.html do
              redirect_to polymorphic_url([
                parent_or_nil,
                commit_and_continue? ? resource : resource_class
              ])
            end
          end
        end
      end
    end

    private

    def commit_and_continue?
      params["commit_and_continue"].present?
    end
  end
end
