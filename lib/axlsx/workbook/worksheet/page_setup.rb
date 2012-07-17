module Axlsx
  # Page setup settings for printing a worksheet. All settings are optional.
  #
  # @note The recommended way to manage print options is via Worksheet#page_setup
  # @see Worksheet#print_options
  # @see Worksheet#initialize
  class PageSetup

    # TODO: Attributes defined by Open XML spec that are not implemented yet:
    # 
    # * blackAndWhite
    # * cellComments
    # * copies
    # * draft
    # * errors
    # * firstPageNumber
    # * horizontalDpi
    # * pageOrder
    # * paperSize
    # * useFirstPageNumber
    # * usePrinterDefaults
    # * verticalDpi
    
    # Number of vertical pages to fit on.
    # @note PageSetup#fit_to is the recomended way to manage page fitting as only specifying one of fit_to_width/fit_to_height will result in the counterpart
    # being set to 1.
     # @return [Integer]
    attr_reader :fit_to_height

    # Number of horizontal pages to fit on.
    # @note PageSetup#fit_to is the recomended way to manage page fitting as only specifying one of width/height will result in the counterpart
    # being set to 1. 
    # @return [Integer]
    attr_reader :fit_to_width

    # Orientation of the page (:default, :landscape, :portrait)
    # @return [Symbol]
    attr_reader :orientation 
    
    # Height of paper (string containing a number followed by a unit identifier: "297mm", "11in")
    # @return [String]
    attr_reader :paper_height

    # Width of paper (string containing a number followed by a unit identifier: "210mm", "8.5in")
    # @return [String]
    attr_reader :paper_width
    
    # Print scaling (percent value, given as integer ranging from 10 to 400)
    # @return [Integer]
    attr_reader :scale

    # Creates a new PageSetup object
    # @option options [Integer] fit_to_height Number of vertical pages to fit on
    # @option options [Integer] fit_to_width Number of horizontal pages to fit on
    # @option options [Symbol] orientation Orientation of the page (:default, :landscape, :portrait)
    # @option options [String] paper_height Height of paper (number followed by unit identifier: "297mm", "11in")
    # @option options [String] paper_width Width of paper (number followed by unit identifier: "210mm", "8.5in")
    # @option options [Integer] scale Print scaling (percent value, integer ranging from 10 to 400)
    def initialize(options = {})
      set(options)
    end

    # Set some or all page settings at once.
    # @param [Hash] options The page settings to set (possible keys are :fit_to_height, :fit_to_width, :orientation, :paper_height, :paper_width, and :scale).
    def set(options)
      options.each do |k, v|
        send("#{k}=", v) if respond_to? "#{k}="
      end
    end

    # @see fit_to_height
    def fit_to_height=(v); Axlsx::validate_unsigned_int(v); @fit_to_height = v; end
    # @see fit_to_width
    def fit_to_width=(v); Axlsx::validate_unsigned_int(v); @fit_to_width = v; end
    # @see orientation
    def orientation=(v); Axlsx::validate_page_orientation(v); @orientation = v; end
    # @see paper_height
    def paper_height=(v); Axlsx::validate_number_with_unit(v); @paper_height = v; end
    # @see paper_width
    def paper_width=(v); Axlsx::validate_number_with_unit(v); @paper_width = v; end
    # @see scale
    def scale=(v); Axlsx::validate_scale_10_400(v); @scale = v; end
    
    # convenience method to achieve sanity when setting fit_to_width and fit_to_height 
    # as they both default to 1 if only their counterpart is specified.
    # @note This method will overwrite any value you explicitly set via the fit_to_height or fit_to_width methods.
    # @option options [Integer] width The number of pages to fit this worksheet on horizontally. Default 9999
    # @option options [Integer] height The number of pages to fit this worksheet on vertically. Default 9999
    def fit_to(options={})
      self.fit_to_width = options[:width] || 9999
      self.fit_to_height = options[:height] || 9999
      [@fit_to_width, @fit_to_height]
    end


    # helper method for worksheet to determine if the page setup is configured for fit to page printing
    # We treat any page set up that has a value set for fit_to_width or fit_to_height value as fit_to_page. 
    # @return [Boolean]
    def fit_to_page?
       # is there some better what to express this?
       (fit_to_width != nil || fit_to_height != nil)
    end

    # Serializes the page settings element.
    # @param [String] str
    # @return [String]
    def to_xml_string(str = '')
      str << '<pageSetup '
      str << instance_values.reject{ |k, v| k == 'worksheet' }.map{ |k,v| k.gsub(/_(.)/){ $1.upcase } << %{="#{v}"} }.join(' ')
      str << '/>'
    end
  end
end
