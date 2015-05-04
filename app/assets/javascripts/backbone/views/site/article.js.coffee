Coreading.Views.Articles ||= {}

class Coreading.Views.Articles.ArticleView extends Backbone.View
  el: '#main-content'

  initialize: (opts)->
    @article = new Coreading.Models.Article(opts)
    @renderArticle()

  renderArticle: =>
    article = @article.toJSON()
    if article.path_type == 'online'
      @$el.html(_.template($('#t-article-show').html())(article: article)) 
    else
      @$el.html(_.template($('#t-article-pdf-show').html())(article: article)) 
      container = document.getElementById('pdf-viewer-container')
      pdfViewer = new PDFJS.PDFViewer({
        container: container
      })
      container.addEventListener 'pagesinit', ->
        pdfViewer.currentScaleValue = 'page-width'
      PDFJS.getDocument(article.pdf_url).then (pdfDocument)->
        pdfViewer.setDocument(pdfDocument)
        
      # container.addEventListener 'pagesloaded', ->
      #   alert('aa')

      Annotator.textSelector($('#pdf-viewer-container'), {article: article});
      Annotator.hoveHighlights();
      setTimeout(Annotator.load, 5000); #tmp
      # Annotator.load();
