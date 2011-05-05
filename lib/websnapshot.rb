#!/usr/bin/ruby
# vim: set ts=2 sts=2 sw=2 tw=0 ff=unix expandtab :

unless defined? Websnapshot

  require 'gtk2'
  require 'webkit'  # https://github.com/danlucraft/rbwebkitgtk


  module Websnapshot
    VERSION = '0.0.3'

    def self.take(url, options = {})
      saved_filename = nil

      w = Gtk::Window.new
      w.signal_connect('destroy') do |*args|
        Gtk.main_quit
      end

      v = Gtk::WebKit::WebView.new
      v.open(url)

      # load-finished is deprecated. We should use notify::load-status
      v.signal_connect('load-finished') do |instance, *signal_related_args|
        begin
          options[:max_width] ||= 960
          options[:max_height] ||= 640
          options[:output_filename] ||= 'snapshot.png'
          options[:output_format] ||= 'png'

          saved_filename = save_viewport(instance.parent_window, options)
        rescue
          puts $!
          puts $@
        ensure
          Gtk.main_quit
        end
      end

      v.signal_connect('notify::load-status') do |instance, *signal_related_args|
        #puts 'notify::load-status ' + v.load_status.to_s
      end

      w.add(v)
      w.show_all

      Gtk.main

      saved_filename
    end

    private

    def self.save_viewport(gdk_window, options)
      win = gdk_window
      win.raise
      win.focus(0)
      win.resize(options[:max_width], options[:max_height])
      win.freeze_updates
      x, y, w, h = win.geometry
      pixbuf = Gdk::Pixbuf.from_drawable(nil, win, 0, 0, [options[:max_width], w].min, [options[:max_height], h].min)
      pixbuf.save(options[:output_filename], options[:output_format])
      return options[:output_filename]
    end

  end
end

