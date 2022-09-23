# Overwrite the manifest to not mess with default imports for JSP when using
# the stimulus controller generator

module Stimulus::Manifest
  extend self

  def generate_from(controllers_path)
    preamble = <<-JS

import { Dropdown, Modal, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"
application.register('dropdown', Dropdown)
application.register('modal', Modal)
application.register('tabs', Tabs)
application.register('popover', Popover)
application.register('toggle', Toggle)
application.register('slideover', Slideover)

import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)

    JS
    [
      preamble,
      extract_controllers_from(controllers_path).collect { |controller_path|
        import_and_register_controller(controllers_path, controller_path)
      }
    ]
  end

  def import_and_register_controller(controllers_path, controller_path)
    controller_path = controller_path.relative_path_from(controllers_path).to_s
    module_path = controller_path.split('.').first
    controller_class_name = module_path.camelize.gsub(/::/, "__")
    tag_name = module_path.remove(/_controller/).gsub(/_/, "-").gsub(/\//, "--")

    <<-JS
import #{controller_class_name} from "./#{module_path}"
application.register("#{tag_name}", #{controller_class_name})

    JS
  end

  def extract_controllers_from(directory)
    (directory.children.select { |e| e.to_s =~ /_controller(\.\w+)+$/ } +
      directory.children.select(&:directory?).collect { |d| extract_controllers_from(d) }
    ).flatten.sort
  end
end