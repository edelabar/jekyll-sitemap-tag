jekyll-sitemap-tag
==================

A Liquid Tag to generate an HTML nested list site map from the pages array.

This is a work in progress, I may expand it with some additional navigation generation features, but for now it creates a nested sitemap from all Pages in a Jekyll site.  It does not currently include Posts.

## Installation

1. Copy the `jekyll-sitemap-tag.rb` file to your jekyll `_plugins` directory.
2. Use the tag on your sitemap page.

## Usage

Add the `render_sitemap` Liquid Tag to the desired page.  given the following Pages:

1. /index.html title="Home"
2. /about.html title="About"
2. /sitemap.html title="Sitemap"
3. /2014/index.html title="Yearly Archive for 2014"
4. /2014/09/index.html title="Monthly Archive for 2014/09"

### Full Sitemap

```liquid
{% render_sitemap %}
```

The tag will render the following:

```html
<ul>
  <li><a href="/index.html">Home</a>
    <ul>
      <li><a href="/about.html">About</a></li>
      <li><a href="/sitemap.html">Sitemap</a></li>
      <li><a href="/2014/index.html">Yearly Archive for 2014</a>
        <ul>
          <li><a href="/2014/09/index.html">Monthly Archive for 2014/09</a></li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
```

or as rendered:

<ul>
  <li><a href="/index.html">Home</a>
    <ul>
      <li><a href="/about.html">About</a></li>
      <li><a href="/sitemap.html">Sitemap</a></li>
      <li><a href="/2014/index.html">Yearly Archive for 2014</a>
        <ul>
          <li><a href="/2014/09/index.html">Monthly Archive for 2014/09</a></li>
        </ul>
      </li>
    </ul>
  </li>
</ul>

### Filtered Sitemap

```liquid
{% render_sitemap sitemap\.html %}
```

Where `sitemap\.html` is a String that will be converted to a [Ruby Regexp using the `Regexp.new(string)` method](http://www.ruby-doc.org/core-2.1.2/Regexp.html#method-c-new).

The tag will render the following:

```html
<ul>
  <li><a href="/index.html">Home</a>
    <ul>
      <li><a href="/about.html">About</a></li>
      <li><a href="/2014/index.html">Yearly Archive for 2014</a>
        <ul>
          <li><a href="/2014/09/index.html">Monthly Archive for 2014/09</a></li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
```

or as rendered:

<ul>
  <li><a href="/index.html">Home</a>
    <ul>
      <li><a href="/about.html">About</a></li>
      <li><a href="/2014/index.html">Yearly Archive for 2014</a>
        <ul>
          <li><a href="/2014/09/index.html">Monthly Archive for 2014/09</a></li>
        </ul>
      </li>
    </ul>
  </li>
</ul>

## Usage Notes

This tag expects every node in the sitemap/url structure to render correctly, so if you don't have an index page in a folder and you have folder listings disabled on your web server, the link will result in a denied page or 404 page.

If you'd like your own yearly/monthly indexes like my examples, checkout out my [Jekyll Temporal Archive Generator ](https://github.com/edelabar/jekyll-temporal-archive-generator) project.  
