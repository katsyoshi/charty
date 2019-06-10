module Charty
  class AdapterNotLoadedError < RuntimeError; end

  class PlotterAdapter
    def self.inherited(adapter_class)
      @adapters ||= []
      @adapters << adapter_class
    end

    def self.create(adapter_name)
      begin
        require "charty/backends/#{adapter_name}"
      rescue LoadError
        require "charty/plugin/backend/#{adapter_name}"
      end
      adapter = @adapters.find {|adapter| adapter::Name.to_s == adapter_name.to_s }
      raise AdapterNotLoadedError.new("Adapter for '#{adapter_name}' is not found.") unless adapter
      adapter.new
    end
  end
end
