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

        # Try specified color first, then default color
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
        # Try specified color
        unless screenshot.color.nil? || screenshot.color == screenshot.default_color
          filename = create_file_name(template_name, screenshot.color)
          if (path = find_template(filename))
            return path
          end
        end

        # Try default color
        filename = create_file_name(template_name, screenshot.default_color)
        if (path = find_template(filename))
          unless screenshot.color.nil? || screenshot.color == screenshot.default_color
            UI.important("No frame found for '#{template_name}' in #{screenshot.color}, falling back to #{screenshot.default_color || 'default'}")
          end
          return path
        end

        nil
      end

      def find_template(filename)
        templates = Dir["#{FrameDownloader.templates_path}/#{filename}.{png,jpg}"]
        UI.verbose("Looking for #{filename} and found #{templates.count} template(s)")
        return templates.first&.tr(" ", "\ ") if templates.any?
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

      def create_file_name(device_name, color)
        color ? "#{device_name} #{color}" : device_name
      end
    end
  end
end