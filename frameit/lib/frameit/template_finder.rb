require 'deliver/app_screenshot'
require_relative 'module'
require_relative 'device_types'
require_relative 'frame_downloader'

module Frameit
  class TemplateFinder
    FRAME_FALLBACK_MAP = {
      Deliver::AppScreenshot::ScreenSize::IOS_65 => "Apple iPhone 14 Pro Max",
      Deliver::AppScreenshot::ScreenSize::IOS_IPAD_11 => "Apple iPad Pro (11-inch)",
      Deliver::AppScreenshot::ScreenSize::IOS_IPAD_13 => "Apple iPad Pro (12.9-inch) (4th generation)"
    }.freeze

    class << self
      def get_template(screenshot)
        return nil if screenshot.mac?

        # Determine which device name to use
        template_name = determine_template_name(screenshot)
        return handle_missing_template(screenshot, template_name) unless template_name

        screenshot.template = template_name

        # Try specified color first, then default color, then any available template
        template_path = find_template_with_color(screenshot, template_name)
        return template_path if template_path

        handle_missing_template(screenshot, template_name)
      end

      private

      def determine_template_name(screenshot)
        # Check primary device name first
        return screenshot.device_name if template_exists?(screenshot.device_name)

        # Check fallback device name
        fallback_name = FRAME_FALLBACK_MAP[screenshot.deliver_screen_id]
        if fallback_name && template_exists?(fallback_name)
          UI.important("No frame found for '#{screenshot.device_name}', falling back to '#{fallback_name}'")
          return fallback_name
        end

        nil
      end

      def find_template_with_color(screenshot, template_name)
        # Get all templates for the device
        templates = Dir["#{FrameDownloader.templates_path}/#{template_name}*.{png,jpg}"]
        UI.verbose("Found #{templates.count} templates for '#{template_name}'")

        return nil if templates.empty?

        # Try matching specified color
        unless screenshot.color.nil? || screenshot.color == screenshot.default_color
          if (path = find_template_with_color_name(templates, screenshot.color, template_name))
            return path
          end
          UI.important("No frame found for '#{template_name}' with color '#{screenshot.color}'")
        end

        # Try matching default color
        if screenshot.default_color
          if (path = find_template_with_color_name(templates, screenshot.default_color, template_name))
            UI.important("Falling back to default color '#{screenshot.default_color}' for '#{template_name}'") unless screenshot.color.nil?
            return path
          end
          UI.important("No frame found for '#{template_name}' with default color '#{screenshot.default_color}'")
        end

        # Fall back to first available template with warning
        UI.user_error!("Warning: No matching color found for '#{template_name}'. Using first available template: '#{templates.first}'. This may not be the expected appearance!")
        templates.first&.tr(" ", "\ ")
      end

      def find_template_with_color_name(templates, color, template_name)
        return nil unless color

        # Look for templates where the color is included in the filename (case-insensitive)
        matching_template = templates.find do |template|
          template.downcase.include?(color.downcase)
        end

        if matching_template
          UI.verbose("Found template '#{matching_template}' matching color '#{color}' for '#{template_name}'")
          return matching_template.tr(" ", "\ ")
        end

        nil
      end

      def template_exists?(device_name)
        # Check for any template files starting with the device name
        templates = Dir["#{FrameDownloader.templates_path}/#{device_name}*.{png,jpg}"]
        UI.verbose("Checking for templates starting with '#{device_name}', found #{templates.count}")
        templates.any?
      end

      def handle_missing_template(screenshot, template_name)
        if screenshot.deliver_screen_id == Deliver::AppScreenshot::ScreenSize::IOS_35
          UI.important("Unfortunately 3.5\" device frames were discontinued. Skipping screen '#{screenshot.path}'")
          UI.error("Looked for: '#{template_name}.png'")
        else
          UI.error("Couldn't find template for screenshot type '#{template_name}'")
          UI.error("Please run `fastlane frameit download_frames` to download the latest frames")
        end
        nil
      end
    end
  end
end