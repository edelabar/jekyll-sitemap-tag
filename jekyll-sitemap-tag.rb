#
# {% sitemap skip_url_regex_string %}
#

module Jekyll

  class SiteMapTag < Liquid::Tag

    def initialize(tag_name, params, tokens)
      super
      
      regex_string = params.split(' ').first
      if( regex_string )
        @regex = Regexp.new(regex_string)
      end
            
    end

    def lookup(context, name)
      lookup = context
      name.split(".").each { |value| lookup = lookup[value] }
      lookup
    end
    
    def render(context)
      
      sitemap = SiteMapNode.new
      pages = lookup(context, 'site.pages')      
      output = ""
      
      sorted_pages = pages.sort { |x,y|
	      x.url <=> y.url
      }
      
      pages.each do |page|
      	
      	# Filter non-html files (.xml for feeds, .css from sass, etc.)
      	if !(/\.html$/ =~ page.url )
          next
      	end
      	
      	# Skip blog pagination
      	if /^\/page\// =~ page.url 
          next
      	end
      	
        # Skip urls that match the passed Regexp (if assigned)
      	if @regex && @regex =~ page.url
      	  next
      	end
      	
	  	sitemap.add_page(page)
      	
      end
      
      %{<ul><li>#{sitemap.markup}</li></ul>}.to_s
    end
    
  end
  
  class SiteMapNode
    attr_reader :page, :key, :children
    
    def initialize
      @children = Hash.new
    end
    
    def add_page(page)
	  
	  sitemap_page = SiteMapPage.new(page.url,page.data['title'])
      
      # create the array of segments and prepare it for populate_page
      segments = page.url.split('/')
      
	  # Now we should have something like this for segments: 
	  #    ['', 'index.html']
	  # or ['', 'page.html']
	  # or ['', 'segment', 'index.html']
	  # or ['', 'segment', 'page.html']
      
      # pull off the leading '', that's the root node (this node).
      @key = segments.shift
      
      self.populate_page(segments,sitemap_page)
      
    end
    
    def populate_leaf(key,page)
      @page = page
      @key = key
    end
    
    def populate_page(segments,sitemap_page)
      
      first_segment = segments.shift
      
      if segments.size == 0
        # leaf node
        if first_segment == 'index.html'
          @key = '' # makes sorting easier later...
          @page = sitemap_page
        else
          leaf_node = SiteMapNode.new
          leaf_node.populate_leaf(first_segment,sitemap_page)
          @children[first_segment] = leaf_node
        end
        
      else
        # recurse
        node = @children[first_segment]
        if !node
          node = SiteMapNode.new
          @children[first_segment] = node
        end
        node.populate_page(segments,sitemap_page)
        
      end
    
    end
    
    def markup
      output = @page.link
      if @children.size
        output += "<ul>"
        @children.values.sort {|x,y| x.page.title <=> y.page.title}.each do |sitemap_node|
          output += "<li>#{sitemap_node.markup}</li>"
        end
        output += "</ul>"
      end
      output
    end
    
    def print_segments(segments)
      output = "["
      segments.each do |segment|
        output += "#{segment}, "
      end
      output += "]"
    end
    
  end
  
  class SiteMapPage
    attr_reader :url, :title
    
    def initialize(url, title) 
    
      @url = url
      @title = title
    
    end
    
    def link 
      %{<a href="#{@url}">#{@title}</a>}.to_s
    end
    
  end
  
end

Liquid::Template.register_tag('render_sitemap', Jekyll::SiteMapTag)
