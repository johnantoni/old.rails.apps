# Shamelessly, and I _mean_ shamelessly extracted from Rick Olson's Acts_As_Authenticated Plugin
class EasyMessagesGenerator < Rails::Generator::NamedBase
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    # Take controller name from the next argument.  Default to the pluralized model name.
    @controller_name = args.shift
    @controller_name ||= ActiveRecord::Base.pluralize_table_names ? @name.pluralize : @name

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path,            "#{class_name}"
      m.class_collisions [], 'EasyMessagesSystem'

      # Controller, helper, views, and test directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('app/helpers', controller_class_path)
      m.directory File.join('app/views', controller_class_path, controller_file_name)
      m.template 'model.rb',
                  File.join('app/models',
                            class_path,
                            "#{file_name}.rb")
                  
      m.template 'easy_messages_helper.rb',
                  File.join('app/helpers', "easy_messages_helper.rb")

      # Controller templates
      %w( message_view messages send_message ).each do |action|
        m.template "#{action}.rhtml",
                   File.join('app/views', controller_class_path, controller_file_name, "#{action}.rhtml")
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_easy_messages_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} easy_messages ModelName [ControllerName]"
    end
end
